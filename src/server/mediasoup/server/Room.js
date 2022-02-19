const protoo = require("protoo-server");
const config = require("./config");
const axios = require('axios');
var EventEmitter = require('events').EventEmitter;

const mediaCodecs = [
  {
    kind: "audio",
    mimeType: "audio/opus",
    clockRate: 48000,
    channels: 2,
  },
  {
    kind: "video",
    mimeType: "video/VP8",
    clockRate: 90000,
    parameters: {
      "x-google-start-bitrate": 1000,
    },
  },
];

class Room extends EventEmitter {
  static async create({ mediasoupWorker, roomId, workerNum }) {
    const protooRoom = new protoo.Room();
    const mediasoupRouter = await mediasoupWorker.createRouter({ mediaCodecs });
    return new Room({
      roomId,
      protooRoom,
      mediasoupRouter,
      workerNum
    });
  }

  constructor({ roomId, protooRoom, mediasoupRouter,workerNum }) {
    super();
    this._roomId = roomId;
    this._workerNum = workerNum;
    this._closed = false;
    this._protooRoom = protooRoom;
    this._mediasoupRouter = mediasoupRouter;
    this._producer = null;
    this._audioProducer = null;
    this._producerId = null;
  }
  close() {

    this._closed = true;

    axios.delete(`https://dev.streaminggate.shop/room-service/room`, {
      Headers: {
        'Content-Type' : 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      },
      data: {
        uuid: this._roomId
      }
    }).then((response) => {
      console.log("룸 삭제 성공")
    })

    // mediasoup Router 닫기

    this._mediasoupRouter.close();


    // protoo Room 닫기

    this._protooRoom.close();


    // Emit 'close' event (Map함수에 룸 삭제위해)
    this.emit('close',this._workerNum);

  }

  handleProtooConnection({ peerId, consume, protooWebSocketTransport }) {
    const existingPeer = this._protooRoom.getPeer(peerId);

    if (existingPeer) {
      console.log("이미 존재하는 peer");
      existingPeer.close();
    }

    let peer;

    // 방에 peer 생성
    try {
      peer = this._protooRoom.createPeer(peerId, protooWebSocketTransport);
    } catch (error) {
      console.log(error.message);
    }

    peer.data.consume = consume;
    peer.data.joined = false;
    peer.data.rtpCapabilities = undefined;
    peer.data.sctpCapabilities = undefined;

    // 만들어진 peer에 이벤트 등록
    peer.on("request", (request, accept, reject) => {
      console.log(`protoo Peer request event ${request.method} ${peer.id}`);

      this._handleProtooRequest(peer, request, accept, reject).catch(
          (error) => {
            console.log(`request failed ${error}`);

            reject(error);
          }
      );
    });
  }

  getRouterRtpCapabilities() {
    return this._mediasoupRouter.rtpCapabilities;
  }

  createWebRtcTransport = async () => {
    try {

      const webRtcTransport_options = {
        ...config.mediasoup.webRtcTransportOptions,
        enableUdp: true,
        enableTcp: true,
        preferUdp: true,
      };
      let transport = await this._mediasoupRouter.createWebRtcTransport(
          webRtcTransport_options
      );
      transport.on("dtlsstatechange", (dtlsState) => {
        if (dtlsState === "closed") {
          transport.close();
        }
      });
      transport.on("close", () => {
        console.log("transport closed");
      });

      const info = {
        id: transport.id,
        iceParameters: transport.iceParameters,
        iceCandidates: transport.iceCandidates,
        dtlsParameters: transport.dtlsParameters,
      };

      return [transport, info];
    } catch (error) {
      console.log(error);
    }
  };

  async _handleProtooRequest(peer, request, accept, reject) {
    switch (request.method) {
      case "getRouterRtpCapabilities": {
        accept(this._mediasoupRouter.rtpCapabilities);
        break;
      }
      case "closeProducer": {
        const { producerId } = request.data;
        const producer = this._protooRoom.getPeer(producerId);
        peer.notify('producerClose',
            {
              message: "방송종료하였습니다."
            })
        accept();
        this.close();
        break;
      }
      case "createWebRtcTransport": {
        // producer
        if (!peer.data.consume) {
          console.log("create produce webRtcTransport");
          const [transport, info] = await this.createWebRtcTransport();
          peer.data.produceTransport = transport;
          accept(info);
        } else {
          // consumer
          console.log("creat consume webRtcTransport");
          console.log("this is flag")
          const [transport, info] = await this.createWebRtcTransport();
          peer.data.consumeTransport = transport;

          accept(info);
        }
        break;
      }
      case "produceConnect": {
        const { dtlsParameters } = request.data;
        if (peer.data?.produceTransport) {
          console.log("produceConnect");
          await peer.data.produceTransport.connect({ dtlsParameters });
          accept(dtlsParameters);
        }
        break;
      }
      case "produceProduce": {
        const { kind, rtpParameters, appData } = request.data;
        if (peer.data?.produceTransport) {
          console.log("produceProduce");
          peer.data.producer = await peer.data.produceTransport.produce({
            kind,
            rtpParameters,
          });
          this._producer = peer.data.producer;
          this._producerId = this._producer.id;
          accept({ id: this._producer.id });
        }
        break;
      }
      case "produceAudioProduce": {
        const { kind, rtpParameters, appData } = request.data;
        if (peer.data?.produceTransport) {
          console.log("produceAudioProduce");
          peer.data.audioProdcuer = await peer.data.produceTransport.produce({
            kind,
            rtpParameters,
          });
          this._audioProducer = peer.data.audioProdcuer;
          accept({ id: this._audioProducer.id });
        }
        break;
      }
      case "connectConsume": {
        //const { dtlsParameters } = request.data;
        const dtlsParameters = typeof request.data.dtlsParameters === 'object'?request.data.dtlsParameters:JSON.parse(request.data.dtlsParameters);
        if (peer.data?.consumeTransport) {
          console.log("connectConsume");
          try {
            await peer.data.consumeTransport.connect({ dtlsParameters });
          } catch (error) {
            console.log(error.message);
          }
        }
        accept();
        break;
      }
      case "consume": {
        // const { rtpCapabilities } = request.data;
        const rtpCapabilities = typeof request.data.rtpCapabilities === 'object'?request.data.rtpCapabilities:JSON.parse(request.data.rtpCapabilities);
        let canConsume = false;
        if (this._producer?.id) {

          canConsume = this._mediasoupRouter.canConsume({
            producerId: this._producer.id,
            rtpCapabilities,
          });
        }

        try {
          if (canConsume && peer.data?.consumeTransport) {
            console.log("consume");
            peer.data.consumer = await peer.data.consumeTransport.consume({
              producerId: this._producer.id,
              rtpCapabilities,
              paused: true,
            });

            peer.data.consumer.on("transportclose", () => {
              console.log("transport close from consumer");
              peer.notify('producerClose',
                  {
                    message: "방송종료하였습니다."
                  })
              // this.close();
            });

            peer.data.consumer.on("producerclose",  async (id) => {
              console.log("producer of consumer closed");
              await peer.notify('producerClose',
                  {
                    message: "방송종료하였습니다."
                  })
              // this.close();
            });

            accept({
              id: peer.data.consumer.id,
              producerId: this._producer.id,
              kind: peer.data.consumer.kind,
              rtpParameters: peer.data.consumer.rtpParameters,
            });
          } else if (!canConsume && peer.data?.consumeTransport) {
            peer.notify("streamUnavailable");
          }
        } catch (error) {
          console.log(error);
        }
        break;
      }
      case "audioConsume": {
        const rtpCapabilities = typeof request.data.rtpCapabilities === 'object' ? request.data.rtpCapabilities : JSON.parse(request.data.rtpCapabilities);
        let canConsume = false;
        if (this._audioProducer?.id) {
          console.log("here");
          canConsume = this._mediasoupRouter.canConsume({
            producerId: this._audioProducer.id,
            rtpCapabilities,
          });
        }
        try {
          if (canConsume && peer.data?.consumeTransport) {
            console.log("audioConsume");
            peer.data.audioConsumer = await peer.data.consumeTransport.consume({
              producerId: this._audioProducer.id,
              rtpCapabilities,
              paused: true,
            });

            peer.data.audioConsumer.on("transportclose", () => {
              console.log("transport close from consumer2");
            });

            peer.data.audioConsumer.on("producerclose", () => {
              console.log("producer of consumer closed2");
            });

            accept({
              id: peer.data.audioConsumer.id,
              producerId: this._audioProducer.id,
              kind: peer.data.audioConsumer.kind,
              rtpParameters: peer.data.audioConsumer.rtpParameters,
            });
          } else if (!canConsume && peer.data?.consumeTransport) {
            peer.notify("streamUnavailable");
          }
        } catch (error) {
          console.log(error);
        }
        break;
      }
      case "consumerResume": {
        console.log("consumer resume");
        if (peer.data?.consumer) {
          await peer.data.consumer.resume();
          accept();
        }
        break;
      }
      case "audioConsumerResume": {
        if (peer.data?.audioConsumer) {
          await peer.data.audioConsumer.resume();
          accept();
        }
        break;
      }
    }
  }
}

module.exports = Room;

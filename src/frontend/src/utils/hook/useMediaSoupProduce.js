import { useEffect, useState } from 'react';
import protooClient from 'protoo-client';

const mediasoupClient = require('mediasoup-client');

/**
 *
 * @param {Object} stream 로컬 미디어 스트림
 * @param {string} roomId 실시간 방송 uuid
 * @param {string} userId 실시간 방송을 진행하는 이용자 uuid
 * @returns {Object}
 * produce: 미디어 서버에 미디어를 전달하는 객체
 */

export default function useMediaSoupProduce(stream, roomId, userId) {
  const [producer, setProducer] = useState(null);

  const getRtpCapabilites = async peer => {
    const rtpCapabilities = await peer.request('getRouterRtpCapabilities');
    return rtpCapabilities;
  };

  const createProducerDevice = async rtpCapabilities => {
    const producerDevice = new mediasoupClient.Device();

    await producerDevice.load({
      routerRtpCapabilities: rtpCapabilities,
    });

    return producerDevice;
  };

  const createProducerTransport = async (peer, producerDevice) => {
    const producerTransportParams = await peer.request('createWebRtcTransport');
    const producerTransport = producerDevice.createSendTransport(producerTransportParams);

    producerTransport.on('connect', async ({ dtlsParameters }, callback, errback) => {
      try {
        await peer.request('produceConnect', {
          dtlsParameters,
        });
        callback();
      } catch (error) {
        errback(error);
      }
    });

    producerTransport.on('produce', async (parameters, callback, errback) => {
      try {
        if (parameters.kind === 'video') {
          const { id } = await peer.request('produceProduce', {
            kind: parameters.kind,
            rtpParameters: parameters.rtpParameters,
            appData: parameters.appData,
          });
          callback(id);
        } else if (parameters.kind === 'audio') {
          const { id } = await peer.request('produceAudioProduce', {
            kind: parameters.kind,
            rtpParameters: parameters.rtpParameters,
            appData: parameters.appData,
          });
          callback(id);
        }
      } catch (error) {
        errback(error);
      }
    });

    return producerTransport;
  };

  const connectWithProduceRouter = async producerTransport => {
    const producer = await producerTransport.produce({
      track: stream.videoTrack,
      // mediasoup params
      // encodings: [
      //   {
      //     rid: 'r0',
      //     maxBitrate: 100000,
      //     scalabilityMode: 'S1T3',
      //   },
      //   {
      //     rid: 'r1',
      //     maxBitrate: 300000,
      //     scalabilityMode: 'S1T3',
      //   },
      //   {
      //     rid: 'r2',
      //     maxBitrate: 900000,
      //     scalabilityMode: 'S1T3',
      //   },
      // ],
      // // https://mediasoup.org/documentation/v3/mediasoup-client/api/#ProducerCodecOptions
      // codecOptions: {
      //   videoGoogleStartBitrate: 1000,
      // },
    });

    producer.on('trackend', () => {
      console.log('track ended');
    });

    producer.on('transportClose', () => {
      console.log('transport ended');
    });

    // 주석
    // console.log(stream.audioTrack.getConstraints());
    const audioProducer = await producerTransport.produce({
      track: stream.audioTrack,
      // encodings: [{ dtx: false }],
    });

    audioProducer.on('trackend', () => {
      console.log('track ended');
    });

    audioProducer.on('transportClose', () => {
      console.log('transport ended');
    });

    return producer;
  };

  /**
   * 미디어 서버에 미디어를 전달하기 위해
   * 필요한 정보를 반환하는 함수를 실행하는 함수
   *
   * @param {Object} peer 미디어 서버의 시그널링 서버와 연결된 객체
   */

  const initProduce = async peer => {
    const rptCapabilities = await getRtpCapabilites(peer);
    const producerDevice = await createProducerDevice(rptCapabilities);
    const producerTransport = await createProducerTransport(peer, producerDevice);
    const producer = await connectWithProduceRouter(producerTransport);

    setProducer(producer);
  };

  useEffect(() => {
    let peer = null;
    if (stream.videoTrack) {
      const transport = new protooClient.WebSocketTransport(
        `${process.env.REACT_APP_LIVE_SOCKET}/?room=${roomId}&peer=${userId}&role=produce`
      );
      peer = new protooClient.Peer(transport);
      peer.on('open', () => {
        initProduce(peer);
      });
    }
    return () => {
      peer?.close();
    };
  }, [stream]);

  return { producer };
}

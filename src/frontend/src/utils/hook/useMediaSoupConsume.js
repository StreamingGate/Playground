import { useState, useEffect } from 'react';
import protooClient from 'protoo-client';

const mediasoupClient = require('mediasoup-client');

export default function useMediaSoupConsume(isLive) {
  const [peer, setPeer] = useState(null);
  const [consumer, setConsumer] = useState(null);

  const getRtpCapabilities = async () => {
    const rptCapabilities = await peer.request('getRouterRtpCapabilities');
    return rptCapabilities;
  };

  const createConsumeDevice = async rptCapabilities => {
    const consumerDevice = new mediasoupClient.Device();

    await consumerDevice.load({
      routerRtpCapabilities: rptCapabilities,
    });

    return consumerDevice;
  };

  const createConsumeTransport = async consumeDevice => {
    const recvTransportParams = await peer.request('createWebRtcTransport');
    const consumerTransport = consumeDevice.createRecvTransport(recvTransportParams);

    consumerTransport.on('connect', async ({ dtlsParameters }, callback, errback) => {
      try {
        await peer.request('connectConsume', {
          dtlsParameters,
        });
        callback();
      } catch (error) {
        errback(error);
      }
    });

    return consumerTransport;
  };

  const connectWithConsumeRouter = async (consumerDevice, consumerTransport) => {
    const params = await peer.request('consume', {
      rtpCapabilities: consumerDevice.rtpCapabilities,
    });

    const consumer = await consumerTransport.consume({
      id: params.id,
      producerId: params.producerId,
      kind: params.kind,
      rtpParameters: params.rtpParameters,
    });

    return consumer;
  };

  const initConsume = async () => {
    const rptCapabilities = await getRtpCapabilities();
    const consumerDevice = await createConsumeDevice(rptCapabilities);
    const consumerTransport = await createConsumeTransport(consumerDevice);
    const newConsumer = await connectWithConsumeRouter(consumerDevice, consumerTransport);

    setConsumer(newConsumer);
  };

  useEffect(() => {
    let newPeer = null;
    if (isLive) {
      const transport = new protooClient.WebSocketTransport(
        'ws://localhost:4443/?room=test1&peer=peer3&role=consume'
      );
      newPeer = new protooClient.Peer(transport);
      setPeer(newPeer);
    }
    return () => {
      newPeer?.close();
    };
  }, []);

  useEffect(() => {
    if (peer) {
      peer.on('open', () => {
        initConsume();
      });
    }
  }, [peer]);

  return { consumer };
}

// const handleProcessConsume = async peer => {
//   try {
//     // get RtpCapbilities
//     const rtpCapabilities = await peer.request('getRouterRtpCapabilities');
//     console.log(rtpCapabilities);

//     // create consume device
//     const newConsumerDevice = new mediasoupClient.Device();

//     await newConsumerDevice.load({
//       routerRtpCapabilities: rtpCapabilities,
//     });

//     // create recv transport
//     const recvTransportParams = await peer.request('createWebRtcTransport');
//     const newConsumerTransport = newConsumerDevice.createRecvTransport(recvTransportParams);

//     newConsumerTransport.on('connect', async ({ dtlsParameters }, callback, errback) => {
//       try {
//         await peer.request('connectConsume', {
//           dtlsParameters,
//         });
//         callback();
//       } catch (error) {
//         errback(error);
//       }
//     });

//     const params = await peer.request('consume', {
//       rtpCapabilities: newConsumerDevice.rtpCapabilities,
//     });

//     const newConsumer = await newConsumerTransport.consume({
//       id: params.id,
//       producerId: params.producerId,
//       kind: params.kind,
//       rtpParameters: params.rtpParameters,
//     });

//     const { track } = newConsumer;
//     console.log(track);
//     videoPlayerRef.current.srcObject = new MediaStream([track]);
//     await peer.request('consumerResume');
//   } catch (error) {
//     console.log(error.message);
//   }
// };

// useEffect(() => {
//   const newTransport = new protooClient.WebSocketTransport(
//     'ws://localhost:4443/?room=test1&peer=peer3&role=consume'
//   );
//   const newPeer = new protooClient.Peer(newTransport);
//   newPeer.on('open', () => {
//     handleProcessConsume(newPeer);
//   });
// }, []);

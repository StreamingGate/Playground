import { useState, useEffect } from 'react';
import protooClient from 'protoo-client';

const mediasoupClient = require('mediasoup-client');

export default function useMediaSoupConsume(isLive, videoPlayerRef, roomId) {
  const [consumer, setConsumer] = useState(null);

  const getRtpCapabilities = async peer => {
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

  const createConsumeTransport = async (peer, consumeDevice) => {
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

  const connectWithConsumeRouter = async (peer, consumerDevice, consumerTransport) => {
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

  const handleVideoLiveLoad = async (peer, consumer) => {
    const { track } = consumer;
    videoPlayerRef.current.srcObject = new MediaStream([track]);
    await peer.request('consumerResume');
  };

  const initConsume = async peer => {
    const rptCapabilities = await getRtpCapabilities(peer);
    const consumerDevice = await createConsumeDevice(rptCapabilities);
    const consumerTransport = await createConsumeTransport(peer, consumerDevice);
    const newConsumer = await connectWithConsumeRouter(peer, consumerDevice, consumerTransport);
    await handleVideoLiveLoad(peer, newConsumer);

    setConsumer(newConsumer);
  };

  useEffect(() => {
    let newPeer = null;
    if (isLive && roomId) {
      const transport = new protooClient.WebSocketTransport(
        `${process.env.REACT_APP_LIVE_SOCKET}/?room=${roomId}&peer=peer3&role=consume`
      );
      newPeer = new protooClient.Peer(transport);

      newPeer.on('open', () => {
        initConsume(newPeer);
      });
    }
    return () => {
      newPeer?.close();
    };
  }, [roomId]);

  return { consumer };
}

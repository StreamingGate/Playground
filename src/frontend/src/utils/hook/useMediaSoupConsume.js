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
    const audioConsumerDevice = new mediasoupClient.Device();

    await consumerDevice.load({
      routerRtpCapabilities: rptCapabilities,
    });

    await audioConsumerDevice.load({
      routerRtpCapabilities: rptCapabilities,
    });

    return { consumerDevice, audioConsumerDevice };
  };

  const createConsumeTransport = async (peer, consumeDevice, audioConsumerDevice) => {
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

    const audioRecvTransportParams = await peer.request('createAudioWebRtcTransport');
    const audioConsumerTransport =
      audioConsumerDevice.createRecvTransport(audioRecvTransportParams);

    audioConsumerTransport.on('connect', async ({ dtlsParameters }, callback, errback) => {
      try {
        await peer.request('connectAudioConsume', {
          dtlsParameters,
        });
        callback();
      } catch (error) {
        errback(error);
      }
    });

    return { consumerTransport, audioConsumerTransport };
  };

  const connectWithConsumeRouter = async (
    peer,
    consumerDevice,
    consumerTransport,
    audioConsumerDevice,
    audioConsumerTransport
  ) => {
    const params = await peer.request('consume', {
      rtpCapabilities: consumerDevice.rtpCapabilities,
    });

    const consumer = await consumerTransport.consume({
      id: params.id,
      producerId: params.producerId,
      kind: params.kind,
      rtpParameters: params.rtpParameters,
    });

    const audioParams = await peer.request('audioConsume', {
      rtpCapabilities: audioConsumerDevice.rtpCapabilities,
    });

    const audioConsumer = await audioConsumerTransport.consume({
      id: audioParams.id,
      producerId: audioParams.producerId,
      kind: audioParams.kind,
      rtpParameters: audioParams.rtpParameters,
    });

    return { consumer, audioConsumer };
  };

  const handleVideoLiveLoad = async (peer, consumer, audioConsumer) => {
    const { track } = consumer;
    const { track: audio } = audioConsumer;

    console.log(track);
    console.log(audio);

    console.log(consumer);
    videoPlayerRef.current.srcObject = new MediaStream([track, audio]);
    await peer.request('consumerResume');
  };

  const initConsume = async peer => {
    const rptCapabilities = await getRtpCapabilities(peer);
    const { consumerDevice, audioConsumerDevice } = await createConsumeDevice(rptCapabilities);
    const { consumerTransport, audioConsumerTransport } = await createConsumeTransport(
      peer,
      consumerDevice,
      audioConsumerDevice
    );
    const { consumer, audioConsumer } = await connectWithConsumeRouter(
      peer,
      consumerDevice,
      consumerTransport,
      audioConsumerDevice,
      audioConsumerTransport
    );
    await handleVideoLiveLoad(peer, consumer, audioConsumer);

    setConsumer(consumer);
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

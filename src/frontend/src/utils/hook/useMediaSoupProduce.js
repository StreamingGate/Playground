import { useEffect, useState } from 'react';
import protooClient from 'protoo-client';

const mediasoupClient = require('mediasoup-client');

export default function useMediaSoupProduce(stream, roomId, userId) {
  const [producer, setProducer] = useState(null);

  const getRtpCapabilites = async peer => {
    const rtpCapabilities = await peer.request('getRouterRtpCapabilities');
    return rtpCapabilities;
  };

  const createProducerDevice = async rtpCapabilities => {
    const producerDevice = new mediasoupClient.Device();
    const producerAudioDevice = new mediasoupClient.Device();

    await producerDevice.load({
      routerRtpCapabilities: rtpCapabilities,
    });

    await producerAudioDevice.load({
      routerRtpCapabilities: rtpCapabilities,
    });

    return { producerDevice, producerAudioDevice };
  };

  const createProducerTransport = async (peer, producerDevice, producerAudioDevice) => {
    const producerTransportParams = await peer.request('createWebRtcTransport');
    const producerTransport = producerDevice.createSendTransport(producerTransportParams);

    const producerAudioTransportParams = await peer.request('createAudioWebRtcTransport');
    const producerAudioTransport = producerAudioDevice.createSendTransport(
      producerAudioTransportParams
    );

    producerTransport.on('connect', async ({ dtlsParameters }, callback, errback) => {
      console.log('hi');
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
        const { id } = await peer.request('produceProduce', {
          kind: parameters.kind,
          rtpParameters: parameters.rtpParameters,
          appData: parameters.appData,
        });
        callback(id);
      } catch (error) {
        errback(error);
      }
    });

    producerAudioTransport.on('connect', async ({ dtlsParameters }, callback, errback) => {
      console.log('hello');
      try {
        await peer.request('produceAudioConnect', {
          dtlsParameters,
        });
        callback();
      } catch (error) {
        errback(error);
      }
    });

    producerAudioTransport.on('produce', async (parameters, callback, errback) => {
      try {
        const { id } = await peer.request('produceAudioProduce', {
          kind: parameters.kind,
          rtpParameters: parameters.rtpParameters,
          appData: parameters.appData,
        });
        callback(id);
      } catch (error) {
        errback(error);
      }
    });

    return { producerTransport, producerAudioTransport };
  };

  const connectWithProduceRouter = async (producerTransport, producerAudioTransport) => {
    const producer = await producerTransport.produce({
      track: stream.videoTrack,
      // mediasoup params
      encodings: [
        {
          rid: 'r0',
          maxBitrate: 100000,
          scalabilityMode: 'S1T3',
        },
        {
          rid: 'r1',
          maxBitrate: 300000,
          scalabilityMode: 'S1T3',
        },
        {
          rid: 'r2',
          maxBitrate: 900000,
          scalabilityMode: 'S1T3',
        },
      ],
      // https://mediasoup.org/documentation/v3/mediasoup-client/api/#ProducerCodecOptions
      codecOptions: {
        videoGoogleStartBitrate: 1000,
      },
    });

    producer.on('trackend', () => {
      console.log('track ended');
    });

    producer.on('transportClose', () => {
      console.log('transport ended');
    });

    const audioProducer = await producerAudioTransport.produce({
      track: stream.audioTrack,
    });

    audioProducer.on('trackend', () => {
      console.log('track ended');
    });

    audioProducer.on('transportClose', () => {
      console.log('transport ended');
    });

    return producer;
  };

  const initProduce = async peer => {
    const rptCapabilities = await getRtpCapabilites(peer);
    const { producerDevice, producerAudioDevice } = await createProducerDevice(rptCapabilities);
    const { producerTransport, producerAudioTransport } = await createProducerTransport(
      peer,
      producerDevice,
      producerAudioDevice
    );
    const producer = await connectWithProduceRouter(producerTransport, producerAudioTransport);

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

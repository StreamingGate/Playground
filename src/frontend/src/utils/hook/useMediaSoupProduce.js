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
        await peer.request('produceProduce', {
          kind: parameters.kind,
          rtpParameters: parameters.rtpParameters,
          appData: parameters.appData,
        });
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

    return producer;
  };

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

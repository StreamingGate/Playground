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
    const producerAudioDevice = new mediasoupClient.Device();

    await producerDevice.load({
      routerRtpCapabilities: rtpCapabilities,
    });

    // 주석
    await producerAudioDevice.load({
      routerRtpCapabilities: rtpCapabilities,
    });

    return { producerDevice, producerAudioDevice };
  };

  const createProducerTransport = async (peer, producerDevice, producerAudioDevice) => {
    const producerTransportParams = await peer.request('createWebRtcTransport');
    const producerTransport = producerDevice.createSendTransport(producerTransportParams);

    // 주석
    const producerAudioTransportParams = await peer.request('createAudioWebRtcTransport');
    const producerAudioTransport = producerAudioDevice.createSendTransport(
      producerAudioTransportParams
    );

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

    // let producerAudioTransport = null;

    // 주석
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

    // 주석
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

  /**
   * 미디어 서버에 미디어를 전달하기 위해
   * 필요한 정보를 반환하는 함수를 실행하는 함수
   *
   * @param {Object} peer 미디어 서버의 시그널링 서버와 연결된 객체
   */

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

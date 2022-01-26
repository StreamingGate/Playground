import React, { useEffect, useState, useRef } from 'react';
import ProtoClient from 'protoo-client';

import { Button } from '@components/buttons';

const mediasoupClient = require('mediasoup-client');

function Test() {
  const [params, setParams] = useState(null);
  const [transport, setTransport] = useState(null);
  const [peer, setPeer] = useState(null);
  const [rtpCapabilities, setRtpCapabilities] = useState(null);
  const [sendTranportParams, setSendTransPortParams] = useState(null);
  const [device, setDevice] = useState(null);
  const [producerTransPort, setProducerTransport] = useState(null);
  const [producer, setProducer] = useState(null);

  const videoRef = useRef(null);

  const streamSuccess = async stream => {
    videoRef.current.srcObject = stream;
    const track = stream.getVideoTracks()[0];
    console.log(track);
    setParams({
      track,
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
  };

  const getLocalStream = () => {
    navigator.getUserMedia(
      {
        audio: false,
        video: {
          width: {
            min: 640,
            max: 1920,
          },
          height: {
            min: 400,
            max: 1080,
          },
        },
      },
      streamSuccess,
      error => {
        console.log(error.message);
      }
    );
  };

  useEffect(() => {
    const tempTransprot = new ProtoClient.WebSocketTransport(
      'wss://streaminggate.shop:443/?roomId=test1&peerId=test2'
    );
    const tempPeer = new ProtoClient.Peer(tempTransprot);

    setTransport(tempTransprot);
    setPeer(tempPeer);
  }, []);

  const handleTest = async () => {
    try {
      const test = await peer.request('getRouterRtpCapabilities', { foo: 'test' });
      setRtpCapabilities(test);
      console.log(test);
    } catch (err) {
      console.log(err);
    }
  };

  const handelCreateDevice = async () => {
    try {
      const testDevice = new mediasoupClient.Device();

      await testDevice.load({
        routerRtpCapabilities: rtpCapabilities,
      });

      console.log('!!!!!!!!!!!!!!!!!!!!!');
      console.log(testDevice);
      console.log('!!!!!!!!!!!!!!!!!!!!!');

      setDevice(testDevice);

      await peer.request('join', {
        // displayName: 'test',
        rtpCapabilities: testDevice.rtpCapabilities,
        sctpCapabilities: testDevice.sctpCapabilities,
      });
    } catch (error) {
      console.log(error);
    }
  };

  const handleCreateSendTransport = async () => {
    try {
      const test = await peer.request('createWebRtcTransport', {
        forceTcp: true,
        producing: true,
        consuming: false,
      });

      console.log('~~~~~~~~~~~~~~~~~~~~~');
      console.log(test);
      console.log('~~~~~~~~~~~~~~~~~~~~~');

      const testProducerTransPort = device.createSendTransport(test);

      console.log('#######################');
      console.log(testProducerTransPort);
      console.log('#######################');

      testProducerTransPort.on('connect', async ({ dtlsParameters }, callback, errback) => {
        try {
          peer.request('connectWebRtcTransport', {
            transportId: testProducerTransPort.id,
            dtlsParameters,
          });
          callback();
        } catch (error) {
          errback(error);
        }
      });

      testProducerTransPort.on('produce', async (parameters, callback, errback) => {
        try {
          const temp = await peer.request('produce', {
            transportId: testProducerTransPort.id,
            kind: parameters.kind,
            rtpParameters: parameters.rtpParameters,
          });
        } catch (error) {
          errback(error);
        }
      });

      setProducerTransport(testProducerTransPort);
    } catch (error) {
      console.log(error.message);
    }
  };

  const handleConnectSendTransport = async () => {
    const testProducer = await producerTransPort.produce(params);

    testProducer.on('trackended', () => {
      console.log('track ended');
    });

    testProducer.on('transportclose', () => {
      console.log('transport close');
    });

    setProducer(testProducer);
  };

  return (
    <>
      <video ref={videoRef} autoPlay></video>
      <Button onClick={getLocalStream}>test</Button>
      <Button onClick={handleTest}>getRtpCapabilities</Button>
      <Button onClick={handelCreateDevice}>CreateDevice</Button>
      <Button onClick={handleCreateSendTransport}>Create Send Transport</Button>
      <Button onClick={handleConnectSendTransport}>Connect Send Transport,</Button>
    </>
  );
}

export default Test;

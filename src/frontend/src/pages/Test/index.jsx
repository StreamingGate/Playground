import React, { useEffect, useState, useRef } from 'react';
import ProtoClient from 'protoo-client';

import { v4 as uuidv4 } from 'uuid';

import { Button } from '@components/buttons';

const mediasoupClient = require('mediasoup-client');

function Test() {
  const [params, setParams] = useState(null);
  const [transport, setTransport] = useState(null);
  const [peer, setPeer] = useState(null);
  const [rtpCapabilities, setRtpCapabilities] = useState(null);
  const [sendTranportParams, setSendTransPortParams] = useState(null);

  const [device, setDevice] = useState(null);
  const [recDevice, setRecDevice] = useState(null);

  const [producerTransPort, setProducerTransport] = useState(null);
  const [consumerTransPort, setConsumerTransPort] = useState(null);

  const [producer, setProducer] = useState(null);
  const [consumer, setConsumer] = useState(null);

  const videoRef = useRef(null);

  const streamSuccess = async stream => {
    videoRef.current.srcObject = stream;
    const track = stream.getVideoTracks()[0];
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
      `wss://18.117.206.241/?roomId=zgbfzgu4&peerId=${uuidv4()}`
    );
    const tempPeer = new ProtoClient.Peer(tempTransprot);
    console.log(tempPeer);
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

      setDevice(testDevice);
    } catch (error) {
      console.log(error);
    }
  };

  const handleCreateRevDevice = async () => {
    try {
      const tempRecDevice = new mediasoupClient.Device();
      await tempRecDevice.load({
        routerRtpCapabilities: rtpCapabilities,
      });

      setRecDevice(tempRecDevice);
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

      console.log(test);

      await peer.request('join', {
        displayName: 'producer',
        rtpCapabilities: device.rtpCapabilities,
        sctpCapabilities: device.sctpCapabilities,
      });

      const testProducerTransPort = device.createSendTransport(test);

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

  const handleCreateRecTransport = async () => {
    try {
      const test = await peer.request('createWebRtcTransport', {
        forceTcp: true,
        producing: false,
        consuming: true,
      });

      console.log(test);

      await peer.request('join', {
        display: 'consumer',
        rtpCapabilities: recDevice.rtpCapabilities,
        sctpCapabilities: recDevice.sctpCapabilities,
      });

      const testConsumerTransPort = recDevice.createRecvTransport(test);

      testConsumerTransPort.on('connect', async ({ dtlsParameters }, callback, errback) => {
        try {
          peer.request('connectWebRtcTransport', {
            transportId: testConsumerTransPort.id,
            dtlsParameters,
          });
          callback();
        } catch (error) {
          errback(error);
        }
      });

      setConsumerTransPort(testConsumerTransPort);
    } catch (error) {
      console.log(error.message);
    }
  };

  const handleConnectSendTransport = async () => {
    await peer.request('consume', { foo: 'a' });
    const testProducer = await producerTransPort.produce(params);

    testProducer.on('trackended', () => {
      console.log('track ended');
    });

    testProducer.on('transportclose', () => {
      console.log('transport close');
    });

    setProducer(testProducer);
  };

  const handleConnectRecTransport = async () => {
    // await peer.request('consume', { foo: 'a' });
    const testConsumer = await consumerTransPort.consume(params);
    console.log(testConsumer);
    setConsumer(testConsumer);
  };

  return (
    <>
      <video ref={videoRef} autoPlay></video>
      <Button onClick={getLocalStream}>test</Button>
      <Button onClick={handleTest}>getRtpCapabilities</Button>
      <Button onClick={handelCreateDevice}>CreateDevice</Button>
      <Button onClick={handleCreateSendTransport}>Create Send Transport</Button>
      <Button onClick={handleConnectSendTransport}>Connect Send Transport,</Button>
      <br />
      <Button onClick={handleCreateRevDevice}>Create Rec Device</Button>
      <Button onClick={handleCreateRecTransport}>Create Rec Transport</Button>
      <Button onClick={handleConnectRecTransport}>Connect Send Transport</Button>
    </>
  );
}

export default Test;

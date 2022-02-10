import React, { useEffect, useRef } from 'react';
import { useParams } from 'react-router-dom';
import protooClient from 'protoo-client';

import * as S from './MobileStudioPage.style';
import { useStreamMedia } from '@utils/hook';

import { IconButton } from '@components/buttons';

const mediasoupClient = require('mediasoup-client');

function MobileStudioPage() {
  const streamPlayerRef = useRef(null);

  const { roomId, hostId } = useParams();
  const { stream, switchCamera, stopStream } = useStreamMedia(streamPlayerRef, 'mobile');

  const handleProcessProduce = async peer => {
    const rtpCapabilities = await peer.request('getRouterRtpCapabilities');

    // create Device
    const newProducerDevice = new mediasoupClient.Device();

    await newProducerDevice.load({
      routerRtpCapabilities: rtpCapabilities,
    });

    const senderTransportParams = await peer.request('createWebRtcTransport');
    const newProducerTransport = newProducerDevice.createSendTransport(senderTransportParams);

    newProducerTransport.on('connect', async ({ dtlsParameters }, callback, errback) => {
      try {
        const dtlsParams = await peer.request('produceConnect', {
          dtlsParameters,
        });
        callback();
      } catch (error) {
        errback(error);
      }
    });

    newProducerTransport.on('produce', async (parameters, callback, errback) => {
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

    const newProducer = await newProducerTransport.produce({
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

    newProducer.on('trackend', () => {
      console.log('track ended');
    });

    newProducer.on('transportClose', () => {
      console.log('transport eneded');
    });
  };

  useEffect(() => {
    if (stream.videoTrack) {
      const newTransport = new protooClient.WebSocketTransport(
        `${process.env.REACT_APP_LIVE_SOCKET}/?room=${roomId}&peer=${hostId}&role=produce`
      );
      const newPeer = new protooClient.Peer(newTransport);
      newPeer.on('open', () => {
        // handleProcessConsume(newPeer);
        handleProcessProduce(newPeer);
      });
    }
  }, [stream]);

  const handleCameraSwitchBtnClick = async () => {
    await switchCamera();
  };

  const handleStopStreamBtnClick = () => {
    stopStream();
  };

  return (
    <S.MobileStudioPageContainer>
      <S.MobileActionContainer>
        <S.MobileStreamStopBtn variant='text' onClick={handleStopStreamBtnClick}>
          종료
        </S.MobileStreamStopBtn>
        <IconButton onClick={handleCameraSwitchBtnClick}>
          <S.SwitchCameraIcon />
        </IconButton>
      </S.MobileActionContainer>
      <S.MobilePlayerContainer>
        <S.MobileStreamPlayer ref={streamPlayerRef} playsInline autoPlay />
      </S.MobilePlayerContainer>
    </S.MobileStudioPageContainer>
  );
}

export default MobileStudioPage;

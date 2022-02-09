import React, { useState, useRef, useEffect } from 'react';
import protooClient from 'protoo-client';

import * as S from './StudioPage.style';
import { useStreamMedia } from '@utils/hook';

import StreamStatusBar from '../StreamStatusBar/StreamStatusBar';
import { ChatRoom } from '@components/chats';
import { IconButton, Button } from '@components/buttons';
import { Mike, Mute, WhiteShare } from '@components/cores';

const mediasoupClient = require('mediasoup-client');

function StudioPage() {
  const streamPlayerRef = useRef(null);

  const { stream, toggleMuteAudio, stopStream } = useStreamMedia(streamPlayerRef);

  const [isMuteToggle, setMuteToggle] = useState(false);
  const [isCounterStop, setIsCounterStop] = useState(false);

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
        'ws://localhost:4443/?room=test1&peer=peer3&role=produce'
      );
      const newPeer = new protooClient.Peer(newTransport);
      newPeer.on('open', () => {
        // handleProcessConsume(newPeer);
        handleProcessProduce(newPeer);
      });
    }
  }, [stream]);

  const handleMuteBtnToggle = () => {
    toggleMuteAudio();
    setMuteToggle(prev => !prev);
  };

  const handleStopStreamBtnClick = () => {
    stopStream();
    setIsCounterStop(true);
  };

  return (
    <S.StudioPageContainer>
      <S.PlayerConatiner>
        <StreamStatusBar isStop={isCounterStop} />
        <S.StreamPlayer ref={streamPlayerRef} autoPlay />
        <S.StreamControlContainer>
          <IconButton onClick={handleMuteBtnToggle}>
            {isMuteToggle ? <Mute /> : <Mike />}
          </IconButton>
          <IconButton>
            <WhiteShare />
          </IconButton>
          <Button size='sm' onClick={handleStopStreamBtnClick}>
            스트림 종료
          </Button>
        </S.StreamControlContainer>
      </S.PlayerConatiner>
      <S.ChatRoomContainer>
        <ChatRoom />
      </S.ChatRoomContainer>
    </S.StudioPageContainer>
  );
}

export default StudioPage;

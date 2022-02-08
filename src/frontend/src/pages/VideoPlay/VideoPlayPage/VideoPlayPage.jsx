import React, { memo, useRef, useState, useEffect } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import protooClient from 'protoo-client';
import Hls from 'hls.js';

import * as S from './VideoPlayPage.style';
import { lStorageService } from '@utils/service';
import { useGetVideoInfo } from '@utils/hook/query';

import VideoMetaData from '@pages/VideoPlay/VideoMetaData/VideoMetaData';
import { ChatRoom } from '@components/chats';

const mediasoupClient = require('mediasoup-client');

function VideoPlayPage() {
  const { pathname } = useLocation();
  const { id } = useParams();
  const userId = lStorageService.getItem('uuid');

  const videoPlayerRef = useRef(null);
  const playType = useRef(pathname.includes('/video-play') ? 'video' : 'live');

  const handleVideoUrlLoad = data => {
    const { streamingUrl } = data;
    const hls = new Hls();

    try {
      hls.loadSource(streamingUrl);
      hls.attachMedia(videoPlayerRef.current);
    } catch (error) {
      console.log(error);
    }
  };

  const { data } = useGetVideoInfo(playType.current, id, userId, handleVideoUrlLoad);

  const handleProcessConsume = async peer => {
    try {
      // get RtpCapbilities
      const rtpCapabilities = await peer.request('getRouterRtpCapabilities');
      console.log(rtpCapabilities);

      // create consume device
      const newConsumerDevice = new mediasoupClient.Device();

      await newConsumerDevice.load({
        routerRtpCapabilities: rtpCapabilities,
      });

      // create recv transport
      const recvTransportParams = await peer.request('createWebRtcTransport');
      const newConsumerTransport = newConsumerDevice.createRecvTransport(recvTransportParams);

      newConsumerTransport.on('connect', async ({ dtlsParameters }, callback, errback) => {
        try {
          await peer.request('connectConsume', {
            dtlsParameters,
          });
          callback();
        } catch (error) {
          errback(error);
        }
      });

      const params = await peer.request('consume', {
        rtpCapabilities: newConsumerDevice.rtpCapabilities,
      });

      const newConsumer = await newConsumerTransport.consume({
        id: params.id,
        producerId: params.producerId,
        kind: params.kind,
        rtpParameters: params.rtpParameters,
      });

      const { track } = newConsumer;
      console.log(track);
      videoPlayerRef.current.srcObject = new MediaStream([track]);
      await peer.request('consumerResume');
    } catch (error) {
      console.log(error.message);
    }
  };

  // useEffect(() => {
  //   const newTransport = new protooClient.WebSocketTransport(
  //     'ws://localhost:4443/?room=test1&peer=peer3&role=consume'
  //   );
  //   const newPeer = new protooClient.Peer(newTransport);
  //   newPeer.on('open', () => {
  //     handleProcessConsume(newPeer);
  //   });
  // }, []);

  return (
    <S.VideoPlayPageContainer>
      <S.PlayerContainer>
        <S.VideoPlayer controls ref={videoPlayerRef} autoPlay>
          Video Load Fail
        </S.VideoPlayer>
      </S.PlayerContainer>
      <S.ChatRoomContainer>
        <ChatRoom />
      </S.ChatRoomContainer>
      <VideoMetaData videoData={data} />
    </S.VideoPlayPageContainer>
  );
}

export default memo(VideoPlayPage);

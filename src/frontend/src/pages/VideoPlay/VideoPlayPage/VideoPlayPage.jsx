import React, { memo, useRef } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import Hls from 'hls.js';

import * as S from './VideoPlayPage.style';
import { lStorageService } from '@utils/service';
import { useMediaSoupConsume } from '@utils/hook';
import { useGetVideoInfo } from '@utils/hook/query';

import VideoMetaData from '@pages/VideoPlay/VideoMetaData/VideoMetaData';
import { ChatRoom } from '@components/chats';

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
  const { consumer } = useMediaSoupConsume(playType.current === 'live');

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
      <VideoMetaData videoData={data} playType={playType} />
    </S.VideoPlayPageContainer>
  );
}

export default memo(VideoPlayPage);

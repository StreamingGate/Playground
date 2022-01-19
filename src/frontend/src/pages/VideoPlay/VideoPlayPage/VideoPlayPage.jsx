import React, { memo } from 'react';

import * as S from './VideoPlayPage.style';
import DummyVideo from '@assets/video/DummyVideo.mp4';

import ChatRoom from '@pages/VideoPlay/ChatRoom/ChatRoom';
import VideoMetaData from '@pages/VideoPlay/VideoMetaData/VideoMetaData';

function VideoPlayPage() {
  return (
    <S.VideoPlayPageContainer>
      <S.PlayerContainer>
        <S.VideoPlayer src={DummyVideo} controls>
          Video Load Fail
        </S.VideoPlayer>
      </S.PlayerContainer>
      <ChatRoom />
      <VideoMetaData />
    </S.VideoPlayPageContainer>
  );
}

export default memo(VideoPlayPage);

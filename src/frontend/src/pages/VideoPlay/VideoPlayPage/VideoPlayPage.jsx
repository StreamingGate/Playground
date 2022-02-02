import React, { memo, useRef, useEffect } from 'react';
import Hls from 'hls.js';

import * as S from './VideoPlayPage.style';

import ChatRoom from '@pages/VideoPlay/ChatRoom/ChatRoom';
import VideoMetaData from '@pages/VideoPlay/VideoMetaData/VideoMetaData';

function VideoPlayPage() {
  const videoPlayerRef = useRef(null);

  useEffect(() => {
    const videoSrc = process.env.REACT_APP_DUMMY_VIDEO;
    const hls = new Hls();
    hls.loadSource(videoSrc);
    hls.attachMedia(videoPlayerRef.current);
  }, []);

  return (
    <S.VideoPlayPageContainer>
      <S.PlayerContainer>
        <S.VideoPlayer controls ref={videoPlayerRef}>
          Video Load Fail
        </S.VideoPlayer>
      </S.PlayerContainer>
      <ChatRoom />
      <VideoMetaData />
    </S.VideoPlayPageContainer>
  );
}

export default memo(VideoPlayPage);

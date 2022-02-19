import React, { memo, useRef, useEffect, useState, useMemo } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import Hls from 'hls.js';

import * as S from './VideoPlayPage.style';
import { ChatInfoContext } from '@utils/context';
import { lStorageService } from '@utils/service';
import { useMediaSoupConsume, useStatusSocket } from '@utils/hook';
import { useGetVideoInfo } from '@utils/hook/query';

import VideoMetaData from '@pages/VideoPlay/VideoMetaData/VideoMetaData';
import { ChatRoom } from '@components/chats';
import { Loading } from '@components/feedbacks';

/**
 * 실시간 방송인지, 업로드된 비디오 인지 확인후
 * 방송종류에 받는 로직을 실행
 *
 * @returns {React.Component} 실시간/비디오 재생 페이지
 */
function VideoPlayPage() {
  const { pathname } = useLocation();
  const { id } = useParams();
  const userId = lStorageService.getItem('uuid');

  const videoPlayerRef = useRef(null);
  const playType = useRef(pathname.includes('/video-play') ? 'video' : 'live');

  const [curUserCount, setCurUserCount] = useState(0);

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

  const { data, isLoading } = useGetVideoInfo(playType.current, id, userId, handleVideoUrlLoad);

  // 실시간 방송일 경우(playType.current === 'live') 실시간 시청 커스텀 훅 실행
  const { consumer } = useMediaSoupConsume(
    playType.current === 'live',
    videoPlayerRef,
    data?.uuid,
    id
  );

  const { stompClient } = useStatusSocket();

  // socket notify when play video
  useEffect(() => {
    if (data && stompClient) {
      const { videoUuid, title } = data;
      stompClient.publish({
        destination: `/app/watch/${userId}`,
        body: JSON.stringify({
          id,
          type: playType.current === 'video' ? 0 : 1,
          videoRoomUuid: videoUuid,
          title,
        }),
      });
    }
  }, [data, stompClient]);

  // socket notify when exit play page
  useEffect(() => {
    return () => {
      if (stompClient) {
        stompClient.publish({
          destination: `/app/watch/${userId}`,
          body: JSON.stringify({}),
        });
      }
    };
  }, [stompClient]);

  const chatInfoContext = useMemo(
    () => ({
      curUserCount,
      setCurUserCount,
    }),
    [curUserCount]
  );

  return (
    <ChatInfoContext.Provider value={chatInfoContext}>
      {isLoading && <Loading />}
      <S.VideoPlayPageContainer>
        <S.PlayerContainer>
          <S.VideoPlayer controls ref={videoPlayerRef} autoPlay>
            Video Load Fail
          </S.VideoPlayer>
        </S.PlayerContainer>
        <S.ChatRoomContainer>
          <ChatRoom
            senderRole='VIEWER'
            videoUuid={playType.current === 'live' ? data?.uuid : data?.videoUuid}
          />
        </S.ChatRoomContainer>
        <VideoMetaData videoData={data} playType={playType} />
      </S.VideoPlayPageContainer>
    </ChatInfoContext.Provider>
  );
}

export default memo(VideoPlayPage);

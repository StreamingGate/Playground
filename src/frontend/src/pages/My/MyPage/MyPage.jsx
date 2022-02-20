import React, { useRef, useState, useEffect, Fragment } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

import * as S from './MyPage.style';
import { useInifinitScroll } from '@utils/hook';
import { useGetMyList } from '@utils/hook/query';
import { lStorageService } from '@utils/service';

import { Typography } from '@components/cores';
import { VideoOverview } from '@components/videos';
import { Loading } from '@components/feedbacks';

function getMyPageTitle(type) {
  let title = '';
  if (type === 'watch') {
    title = '시청한 동영상';
  } else if (type === 'liked') {
    title = '좋아요 표시한 동영상';
  } else {
    title = '내 동영상';
  }

  return title;
}

function MyPage() {
  const scrollFlag = useRef(null);

  const navigate = useNavigate();
  const { type } = useParams();
  const userId = lStorageService.getItem('uuid');

  const [myPageTitle, setMyPageTitle] = useState('');

  const { data, fetchNextPage, isLoading, isFetching, isFetchingNextPage } = useGetMyList(
    type,
    userId
  );
  const observer = useInifinitScroll(fetchNextPage, {
    root: null,
    threshold: 0,
  });

  useEffect(() => {
    if (!['watch', 'liked', 'upload'].includes(type)) {
      navigate('/mypage/watched');
    }

    if (scrollFlag.current) observer.observe(scrollFlag.current);
  }, []);

  useEffect(() => {
    setMyPageTitle(getMyPageTitle(type));
  }, [type]);

  return (
    <>
      {(isLoading || isFetching || isFetchingNextPage) && <Loading />}
      <S.HistoryPageContainer>
        <Typography>{myPageTitle}</Typography>
        <S.MyVideoContainer>
          {data?.pages.map((group, i) => (
            <Fragment key={i}>
              {type === 'upload' ? (
                group.map(videoInfo => (
                  <VideoOverview
                    key={`video_${videoInfo.id}`}
                    direction='horizontal'
                    videoInfo={videoInfo}
                    isLibrary={type === 'upload'}
                  />
                ))
              ) : (
                <>
                  {group.rooms.map(liveInfo => (
                    <VideoOverview
                      key={`live_${liveInfo.id}`}
                      direction='horizontal'
                      videoInfo={liveInfo}
                      isLibrary={type === 'upload'}
                    />
                  ))}
                  {group.videos.map(videoInfo => (
                    <VideoOverview
                      key={`video_${videoInfo.id}`}
                      direction='horizontal'
                      videoInfo={videoInfo}
                      isLibrary={type === 'upload'}
                    />
                  ))}
                </>
              )}
            </Fragment>
          ))}
        </S.MyVideoContainer>
      </S.HistoryPageContainer>
      <div ref={scrollFlag} />
    </>
  );
}

export default MyPage;

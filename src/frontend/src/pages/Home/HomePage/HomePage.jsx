import React, { Fragment, useCallback, useEffect, useRef } from 'react';

import * as S from './HomePage.sytle';
import { useInifinitScroll } from '@utils/hook';
import { useMainVideoList } from '@utils/hook/query';
import ThumbNailDummy from '@assets/image/ThumbNailDummy.jpg';

import CategorySlider from '../CategorySlider/CategorySlider';
import { VideoOverview } from '@components/videos';

function HomePage() {
  const scrollFlag = useRef(null);
  const { data, fetchNextPage } = useMainVideoList();

  const observer = useInifinitScroll(fetchNextPage, {
    root: null,
    threshold: 0,
  });

  useEffect(() => {
    if (scrollFlag.current) observer.observe(scrollFlag.current);
  }, []);

  return (
    <>
      <CategorySlider />
      <S.HomePageContainer>
        {data?.pages.map((group, i) => (
          <Fragment key={i}>
            {group.liveRooms.map(liveInfo => (
              <VideoOverview key={`live_${liveInfo.id}`} isLive videoInfo={liveInfo} />
            ))}
            {group.videos.map(videoInfo => (
              <VideoOverview key={`video_${videoInfo.id}`} videoInfo={videoInfo} />
            ))}
          </Fragment>
        ))}
        <div ref={scrollFlag} />
      </S.HomePageContainer>
    </>
  );
}

export default HomePage;

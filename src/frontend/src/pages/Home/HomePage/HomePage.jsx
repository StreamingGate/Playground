import React, { Fragment, useState, useEffect, useRef } from 'react';

import * as S from './HomePage.sytle';
import { useInifinitScroll } from '@utils/hook';
import { useMainVideoList } from '@utils/hook/query';

import CategorySlider from '../CategorySlider/CategorySlider';
import { VideoOverview } from '@components/videos';

function HomePage() {
  const scrollFlag = useRef(null);

  const [categories, setCategories] = useState([
    { id: 'ALL', category: '전체' },
    { id: 'SPORTS', category: '스포츠' },
    { id: 'KPOP', category: 'K-POP' },
    { id: 'EDU', category: '교육' },
  ]);
  const [categoryToggleState, setCategoryToggleStates] = useState([]);
  const [selectedCateogory, setSelectedCategory] = useState('ALL');

  const { data, fetchNextPage, hasNextPage } = useMainVideoList(selectedCateogory);

  const observer = useInifinitScroll(fetchNextPage, {
    root: null,
    threshold: 0,
  });

  useEffect(() => {
    const initCategoryToggle = new Array(categories.length).fill(false);
    initCategoryToggle[0] = true;
    setCategoryToggleStates(initCategoryToggle);

    if (scrollFlag.current) observer.observe(scrollFlag.current);
  }, []);

  const handleCategoryChipClick = selectedIdx => () => {
    const newCategoryToggle = [...categoryToggleState];
    let selectedCategoryIdx = -1;

    // prevent ALL category from toggling
    if (selectedIdx === 0 && newCategoryToggle[selectedIdx]) {
      return;
    }

    if (newCategoryToggle[selectedIdx]) {
      newCategoryToggle[0] = true;
      newCategoryToggle[selectedIdx] = false;
      selectedCategoryIdx = 0;
    } else {
      newCategoryToggle.forEach((_, idx) => {
        if (idx === selectedIdx) {
          newCategoryToggle[idx] = true;
          selectedCategoryIdx = idx;
        } else {
          newCategoryToggle[idx] = false;
        }
      });
    }
    setCategoryToggleStates(newCategoryToggle);
    setSelectedCategory(categories[selectedCategoryIdx].id);
  };

  return (
    <>
      <CategorySlider
        categories={categories}
        onToggleCategory={handleCategoryChipClick}
        toggleState={categoryToggleState}
      />
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

import React, { useState, useContext, useRef, useEffect } from 'react';

import * as S from './CategorySlider.style';
import { MainLayoutContext } from '@utils/context';

import { ChipButton } from '@components/buttons';

const dummyCateogry = [
  { id: 1, category: '전체' },
  { id: 2, category: '믹스' },
  { id: 3, category: '음악' },
  { id: 13, category: '게임' },
  { id: 4, category: 'K-POP' },
  { id: 5, category: '교육' },
  { id: 6, category: '애니메이션' },
  { id: 7, category: '실시간' },
  { id: 8, category: '영화' },
  { id: 9, category: '액션 어드벤처 게임' },
  { id: 10, category: '반려동물' },
  { id: 11, category: '최근에 업로드 된 영상' },
  { id: 12, category: 'This is Test' },
];

const MOVING_DIR = 150;

function CategorySlider() {
  const categoryContainerRef = useRef(null);
  const lastCateogriesRef = useRef(null);
  const intialLastCategoryPos = useRef(null);

  const { sideNavState } = useContext(MainLayoutContext);

  const [categoryToggle, setCategoryToggle] = useState([]);
  const [scrollDist, setScrollDist] = useState(0);
  const [isShowNextBtn, setShowNextBtn] = useState(true);

  useEffect(() => {
    intialLastCategoryPos.current = lastCateogriesRef.current.getBoundingClientRect().right;

    const initCategoryToggle = new Array(dummyCateogry.length).fill(false);
    initCategoryToggle[0] = true;
    setCategoryToggle(initCategoryToggle);
  }, []);

  useEffect(() => {
    const categoryContainerPos = categoryContainerRef.current.getBoundingClientRect().right;
    if (categoryContainerPos >= intialLastCategoryPos.current + scrollDist) {
      setShowNextBtn(false);
    } else {
      setShowNextBtn(true);
    }
  }, [scrollDist]);

  const handleArrowLeftBtnClick = () => {
    setScrollDist(prev => prev + MOVING_DIR);
  };

  const handleArrowRightBtnClick = () => {
    setScrollDist(prev => prev - MOVING_DIR);
  };

  const handleCategoryChipClick = selectedIdx => () => {
    const newCategoryToggle = [...categoryToggle];

    if (selectedIdx === 0 && newCategoryToggle[selectedIdx]) {
      return;
    }

    if (newCategoryToggle[selectedIdx]) {
      newCategoryToggle[0] = true;
      newCategoryToggle[selectedIdx] = false;
    } else {
      newCategoryToggle.forEach((_, idx) => {
        if (idx === selectedIdx) {
          newCategoryToggle[idx] = true;
        } else {
          newCategoryToggle[idx] = false;
        }
      });
    }

    setCategoryToggle(newCategoryToggle);
  };

  return (
    <S.CategorySliderContainer sideNavState={sideNavState}>
      {scrollDist !== 0 && (
        <S.LeftArrowButtonContainer>
          <S.ArrowLeftIcon onClick={handleArrowLeftBtnClick} />
        </S.LeftArrowButtonContainer>
      )}
      <S.CategoryContainer ref={categoryContainerRef}>
        <S.Categories xPos={scrollDist}>
          {dummyCateogry.map(({ id, category }, idx, arr) => (
            <ChipButton
              key={id}
              content={category}
              ref={idx === arr.length - 1 ? lastCateogriesRef : null}
              isSelected={categoryToggle[idx]}
              onClick={handleCategoryChipClick(idx)}
            />
          ))}
        </S.Categories>
      </S.CategoryContainer>
      {isShowNextBtn && (
        <S.RightArrowButtonContainer>
          <S.ArrowRightIcon onClick={handleArrowRightBtnClick} />
        </S.RightArrowButtonContainer>
      )}
    </S.CategorySliderContainer>
  );
}

export default CategorySlider;

import React, { useState, useContext, useRef, useEffect } from 'react';

import * as S from './CategorySlider.style';
import { MainLayoutContext } from '@utils/context';

import { ChipButton } from '@components/buttons';

const MOVING_DIR = 150;

function CategorySlider({ categories, toggleState, onClick }) {
  const categoryContainerRef = useRef(null);
  const lastCateogriesRef = useRef(null);
  const intialLastCategoryPos = useRef(null);

  const { sideNavState } = useContext(MainLayoutContext);

  const [scrollDist, setScrollDist] = useState(0);
  const [isShowNextBtn, setShowNextBtn] = useState(true);

  useEffect(() => {
    intialLastCategoryPos.current = lastCateogriesRef.current.getBoundingClientRect().right;
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

  return (
    <S.CategorySliderContainer sideNavState={sideNavState}>
      {scrollDist !== 0 && (
        <S.LeftArrowButtonContainer>
          <S.ArrowLeftIcon onClick={handleArrowLeftBtnClick} />
        </S.LeftArrowButtonContainer>
      )}
      <S.CategoryContainer ref={categoryContainerRef}>
        <S.Categories xPos={scrollDist}>
          {categories.map(({ id, category }, idx, arr) => (
            <ChipButton
              key={id}
              content={category}
              ref={idx === arr.length - 1 ? lastCateogriesRef : null}
              isSelected={toggleState[idx]}
              onClick={onClick(idx)}
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

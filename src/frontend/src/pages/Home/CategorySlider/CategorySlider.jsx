import React, { useContext } from 'react';

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

function CategorySlider() {
  const { sideNavState } = useContext(MainLayoutContext);
  return (
    <S.CategorySliderContainer sideNavState={sideNavState}>
      <S.ArrowLeftIcon />
      <S.CategoryContainer>
        {dummyCateogry.map(({ id, category }) => (
          <ChipButton key={id} content={category} />
        ))}
      </S.CategoryContainer>
      <S.ArrowRightIcon />
    </S.CategorySliderContainer>
  );
}

export default CategorySlider;

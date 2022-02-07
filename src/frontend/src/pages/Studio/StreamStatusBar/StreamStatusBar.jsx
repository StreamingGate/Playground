import React, { useState, useEffect, useRef } from 'react';

import * as S from './StreamStatusBar.style';

import { Viewers, Like } from '@components/cores';

function StreamStatusBar() {
  const timer = useRef(null);

  const [count, setCount] = useState(0);

  useEffect(() => {
    timer.current = setInterval(() => {
      setCount(prev => prev + 1);
    }, [1000]);
    return () => {
      clearInterval(timer.current);
    };
  }, []);

  return (
    <S.StreamStatusBarContainer>
      <S.TimerContainer>
        <S.TimerTitle type='caption'>실시간</S.TimerTitle>
        <S.Timer type='caption'>{new Date(count * 1000).toISOString().substring(11, 19)}</S.Timer>
      </S.TimerContainer>
      <S.ViewerCountContainer>
        <Viewers />
        <S.ViewerCount type='caption'>3</S.ViewerCount>
      </S.ViewerCountContainer>
      <S.LikeCountContaienr>
        <Like />
        <S.LikeCount type='caption'>1</S.LikeCount>
      </S.LikeCountContaienr>
    </S.StreamStatusBarContainer>
  );
}

export default StreamStatusBar;

import React, { useRef, useEffect } from 'react';
import lottie from 'lottie-web';

import * as S from './Loading.style';
import loading from '@utils/constant/loading.json';

import { BackDrop } from '@components/feedbacks';

function Loading() {
  const loadingRef = useRef(null);

  useEffect(() => {
    lottie.loadAnimation({
      container: loadingRef.current,
      renderer: 'svg',
      loop: true,
      autoplay: true,
      animationData: loading,
    });
  }, []);

  return (
    <div>
      <BackDrop isOpen zIndex={3} />
      <S.LoadingModalContainer ref={loadingRef} />
    </div>
  );
}

export default Loading;

import React, { useEffect, useState, useRef } from 'react';

import * as S from './MobileStudioPage.style';
import { useStreamMedia } from '@utils/hook';

import { IconButton } from '@components/buttons';

function MobileStudioPage() {
  const streamPlayerRef = useRef(null);
  const { stream, switchCamera, stopStream } = useStreamMedia(streamPlayerRef, 'mobile');

  useEffect(() => {
    // alert('아이폰으로 접근시 어떤 문구 나오는지 알려주세요!!');
    // alert(navigator.userAgent);
  }, []);

  const handleCameraSwitchBtnClick = () => {
    switchCamera();
  };

  const handleStopStreamBtnClick = () => {
    console.log('hi');
    stopStream();
  };

  return (
    <S.MobileStudioPageContainer>
      <S.MobileActionContainer>
        <S.MobileStreamStopBtn variant='text' onClick={handleStopStreamBtnClick}>
          종료
        </S.MobileStreamStopBtn>
        <IconButton onClick={handleCameraSwitchBtnClick}>
          <S.SwitchCameraIcon />
        </IconButton>
      </S.MobileActionContainer>
      <S.MobilePlayerContainer>
        <S.MobileStreamPlayer ref={streamPlayerRef} />
      </S.MobilePlayerContainer>
    </S.MobileStudioPageContainer>
  );
}

export default MobileStudioPage;

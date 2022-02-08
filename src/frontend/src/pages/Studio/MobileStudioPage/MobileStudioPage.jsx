import React, { useEffect, useState, useRef } from 'react';

import * as S from './MobileStudioPage.style';
import { useStreamMedia } from '@utils/hook';

import { IconButton } from '@components/buttons';

function MobileStudioPage() {
  const streamPlayerRef = useRef(null);
  const { stream, switchCamera, stopStream } = useStreamMedia(streamPlayerRef, 'mobile');

  const handleCameraSwitchBtnClick = async () => {
    await switchCamera();
  };

  const handleStopStreamBtnClick = () => {
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
        <S.MobileStreamPlayer ref={streamPlayerRef} playsInline autoPlay />
      </S.MobilePlayerContainer>
    </S.MobileStudioPageContainer>
  );
}

export default MobileStudioPage;

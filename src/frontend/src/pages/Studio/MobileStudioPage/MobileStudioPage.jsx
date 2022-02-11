import React, { useRef } from 'react';
import { useParams } from 'react-router-dom';

import * as S from './MobileStudioPage.style';
import { useStreamMedia, useMediaSoupProduce } from '@utils/hook';

import { IconButton } from '@components/buttons';

/**
 *
 * @returns {React.Component} 실시간 방송 진행 페이지 모바일 웹뷰
 */
function MobileStudioPage() {
  const streamPlayerRef = useRef(null);

  const { roomId, hostId } = useParams();
  // 모바일로 미디어 스트림 생성
  const { stream, switchCamera, stopStream } = useStreamMedia(streamPlayerRef, 'mobile');

  const { producer } = useMediaSoupProduce(stream, roomId, hostId);

  // 전, 후면 카메라 전환 함수
  const handleCameraSwitchBtnClick = async () => {
    await switchCamera();
  };

  // 로컬 미디어 스트림 종료 함수
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

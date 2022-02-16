import React, { useRef } from 'react';
import { useParams } from 'react-router-dom';

import * as S from './MobileStudioPage.style';
import { modalService } from '@utils/service';
import { useStreamMedia, useMediaSoupProduce } from '@utils/hook';

import { AdviseModal } from '@components/feedbacks/Modals';

import { IconButton } from '@components/buttons';

/**
 *
 * @returns {React.Component} 실시간 방송 진행 페이지 모바일 웹뷰
 */
function MobileStudioPage() {
  const streamPlayerRef = useRef(null);
  const urlShemeRef = useRef(null);

  const { roomId, hostId } = useParams();
  // 모바일로 미디어 스트림 생성
  const { stream, switchCamera, stopStream } = useStreamMedia(streamPlayerRef, 'mobile');

  const { producer, newPeer } = useMediaSoupProduce(stream, roomId, hostId);

  // 전, 후면 카메라 전환 함수
  const handleCameraSwitchBtnClick = async () => {
    await switchCamera();
  };

  // 로컬 미디어 스트림 종료 함수
  const handleStopStreamBtnClick = async e => {
    e.preventDefault();
    modalService.show(AdviseModal, {
      content: '방송을 종료하시겠습니까?',
      type: 'cancel',
      cancelBtnContent: '취소',
      btnContent: '종료',
      onClick: async () => {
        stopStream();
        // await newPeer.request('closeProducer', { producerId: producer.id });
        window.location.href = urlShemeRef.current.href;
      },
    });
  };

  return (
    <S.MobileStudioPageContainer>
      <S.MobileActionContainer>
        {/* <S.MobileStreamStopBtn variant='text' onClick={handleStopStreamBtnClick}>
          종료
        </S.MobileStreamStopBtn> */}
        <S.MobileStreamStopBtn
          href='playground://producerClose'
          ref={urlShemeRef}
          onClick={handleStopStreamBtnClick}
        >
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

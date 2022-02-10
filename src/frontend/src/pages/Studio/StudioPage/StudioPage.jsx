import React, { useState, useRef } from 'react';
import { useParams } from 'react-router-dom';

import * as S from './StudioPage.style';
import { useStreamMedia, useMediaSoupProduce } from '@utils/hook';
import { lStorageService } from '@utils/service';

import StreamStatusBar from '../StreamStatusBar/StreamStatusBar';
import { ChatRoom } from '@components/chats';
import { IconButton, Button } from '@components/buttons';
import { Mike, Mute, WhiteShare } from '@components/cores';

function StudioPage() {
  const streamPlayerRef = useRef(null);

  const { stream, toggleMuteAudio, stopStream } = useStreamMedia(streamPlayerRef);
  const { roomId } = useParams();
  const userId = lStorageService.getItem('uuid');

  const { producer } = useMediaSoupProduce(stream, roomId, userId);

  const [isMuteToggle, setMuteToggle] = useState(false);
  const [isCounterStop, setIsCounterStop] = useState(false);

  const handleMuteBtnToggle = () => {
    toggleMuteAudio();
    setMuteToggle(prev => !prev);
  };

  const handleStopStreamBtnClick = () => {
    stopStream();
    setIsCounterStop(true);
  };

  return (
    <S.StudioPageContainer>
      <S.PlayerConatiner>
        <StreamStatusBar isStop={isCounterStop} />
        <S.StreamPlayer ref={streamPlayerRef} autoPlay muted />
        <S.StreamControlContainer>
          <IconButton onClick={handleMuteBtnToggle}>
            {isMuteToggle ? <Mute /> : <Mike />}
          </IconButton>
          <IconButton>
            <WhiteShare />
          </IconButton>
          <Button size='sm' onClick={handleStopStreamBtnClick}>
            스트림 종료
          </Button>
        </S.StreamControlContainer>
      </S.PlayerConatiner>
      <S.ChatRoomContainer>
        <ChatRoom />
      </S.ChatRoomContainer>
    </S.StudioPageContainer>
  );
}

export default StudioPage;

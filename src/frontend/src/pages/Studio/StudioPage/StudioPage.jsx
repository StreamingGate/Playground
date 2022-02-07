import React, { useState, useRef } from 'react';

import * as S from './StudioPage.style';
import { useStreamMedia } from '@utils/hook';

// 컴포넌트 이동 예정
import ChatRoom from '../../VideoPlay/ChatRoom/ChatRoom';
import { IconButton, Button } from '@components/buttons';
import { Mike, Mute, WhiteShare } from '@components/cores';

function StudioPage() {
  const streamPlayerRef = useRef(null);

  const { stream, toggleMuteAudio } = useStreamMedia(streamPlayerRef);

  const [isMuteToggle, setMuteToggle] = useState(false);

  const handleMuteBtnToggle = () => {
    toggleMuteAudio();
    setMuteToggle(prev => !prev);
  };

  return (
    <S.StudioPageContainer>
      <S.PlayerConatiner>
        <S.StreamPlayer ref={streamPlayerRef} />
        <S.StreamControlContainer>
          <IconButton onClick={handleMuteBtnToggle}>
            {isMuteToggle ? <Mute /> : <Mike />}
          </IconButton>
          <IconButton>
            <WhiteShare />
          </IconButton>
          <Button size='sm'>스트림 종료</Button>
        </S.StreamControlContainer>
      </S.PlayerConatiner>
      <ChatRoom />
    </S.StudioPageContainer>
  );
}

export default StudioPage;

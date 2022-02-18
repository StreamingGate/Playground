import React, { useEffect, useState, useRef, useContext } from 'react';
import { useParams } from 'react-router-dom';
import { v4 as uuidv4 } from 'uuid';

import * as S from './ChatRoom.style';
import { ChatInfoContext } from '@utils/context';
import { useSocket, useForm } from '@utils/hook';

import { Typography } from '@components/cores';
import { Input } from '@components/forms';
import { IconButton } from '@components/buttons';
import { ChatDialog } from '@components/dataDisplays';

const MAX_LENGTH = 200;

function ChatRoom({ senderRole, videoUuid }) {
  const { setCurUserCount } = useContext(ChatInfoContext);

  const { roomId } = useParams();
  const chatListContainerRef = useRef(null);

  // 스트리머일 경우 url 주소로 만들어진 방 번호로 소켓 연결
  // 시청자일 경우 상위 컴포넌트에서 전달받은 방 번호로 소켓 연결
  const { chatData, curUserCount, pinnedChat, sendChatMessage } = useSocket(
    senderRole === 'STREAMER' ? roomId : videoUuid,
    senderRole
  );
  const { values, handleInputChange, changeValue } = useForm({ initialValues: { message: '' } });

  const [isShowScrollBtm, setShowScrollBtm] = useState(false);
  const [isPinnedCheck, setPinnedCheck] = useState(false);

  const handleChatListScroll = () => {
    const chatListContainerDom = chatListContainerRef.current;

    const currentScrollHeight = chatListContainerDom.scrollHeight;
    const currentScrollPos = chatListContainerDom.scrollTop + chatListContainerDom.clientHeight;

    if (currentScrollHeight - currentScrollPos >= 35) {
      setShowScrollBtm(true);
    } else {
      setShowScrollBtm(false);
    }
  };

  useEffect(() => {
    chatListContainerRef.current.addEventListener('scroll', handleChatListScroll);

    return () => {
      chatListContainerRef.current.removeEventListener('scroll', handleChatListScroll);
    };
  }, []);

  // 스튜디오 페이지 및 라이브 재생 메타 데이터 업데이트를 위한 컨텍스트
  useEffect(() => {
    setCurUserCount(curUserCount);
  }, [curUserCount]);

  useEffect(() => {
    const currentHeight = chatListContainerRef.current.scrollHeight;

    if (!isShowScrollBtm) {
      chatListContainerRef.current.scroll(0, currentHeight);
    }
  }, [chatData]);

  const handleSendBtn = e => {
    const { message } = values;
    if (!message || message.length > MAX_LENGTH) {
      return;
    }
    if (e.key === 'Enter' || e.type === 'click') {
      sendChatMessage(message, isPinnedCheck);
      changeValue(['message', '']);
    }
  };

  const handleInputLineBreak = e => {
    if (e.key === 'Enter') {
      e.preventDefault();
    }
  };

  const handleScrollToBtmBtnClick = () => {
    const currentHeight = chatListContainerRef.current.scrollHeight;
    chatListContainerRef.current.scroll({
      top: currentHeight,
      behavior: 'smooth',
    });
  };

  const handlePinnedCheckChange = () => {
    setPinnedCheck(prev => !prev);
  };

  return (
    <S.ChatRoomContainer>
      <S.ChatRoomHeader>
        <S.ChatRoomTitle type='component'>실시간 채팅</S.ChatRoomTitle>
        <S.ChatMetaContainer>
          <S.PersonIcon />
          <S.ChatRoomPeople>{curUserCount} 명</S.ChatRoomPeople>
        </S.ChatMetaContainer>
      </S.ChatRoomHeader>
      <S.ChaListContainer ref={chatListContainerRef}>
        {pinnedChat && (
          <S.pinnedChatContainer>
            <ChatDialog chatInfo={pinnedChat} isPinned />
          </S.pinnedChatContainer>
        )}
        {chatData.map(chatInfo => (
          <ChatDialog key={uuidv4()} chatInfo={chatInfo} />
        ))}
        {isShowScrollBtm && (
          <S.ScrollDownBtnContainer>
            <S.ScrollDownBtn onClick={handleScrollToBtmBtnClick} />
          </S.ScrollDownBtnContainer>
        )}
      </S.ChaListContainer>
      <S.ChatInputController>
        <S.UserProfile />
        <S.ChatInputContainer>
          <Input
            name='message'
            placeholder='닉네임으로 채팅하기'
            fullWidth
            variant='standard'
            multiLine
            onKeyPress={handleInputLineBreak}
            onKeyUp={handleSendBtn}
            value={values.message}
            onChange={handleInputChange}
          />
          <S.ChatInputUnderContainer>
            {senderRole === 'STREAMER' && (
              <S.CheckBoxLabel>
                <input type='checkbox' value={isPinnedCheck} onChange={handlePinnedCheckChange} />
                <Typography type='bottomTab'>채팅방 상단 고정</Typography>
              </S.CheckBoxLabel>
            )}
            <S.InputCharCount isLimit={values.message.length > MAX_LENGTH}>
              {values.message.length}/{MAX_LENGTH}
            </S.InputCharCount>
          </S.ChatInputUnderContainer>
        </S.ChatInputContainer>
        <IconButton onClick={handleSendBtn} disabled={!values.message}>
          <S.SendIcon />
        </IconButton>
      </S.ChatInputController>
    </S.ChatRoomContainer>
  );
}

export default ChatRoom;

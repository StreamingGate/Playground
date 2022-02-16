import React, { useEffect, useState, useRef } from 'react';
import { v4 as uuidv4 } from 'uuid';

import * as S from './ChatRoom.style';
import { useSocket, useForm } from '@utils/hook';

import { Input } from '@components/forms';
import { IconButton } from '@components/buttons';
import { ChatDialog } from '@components/dataDisplays';

const MAX_LENGTH = 200;

function ChatRoom({ senderRole }) {
  const chatListContainerRef = useRef(null);
  const { chatData, curUserCount, pinnedChat, sendChatMessage } = useSocket('room3', senderRole);
  const { values, handleInputChange, changeValue } = useForm({ initialValues: { message: '' } });

  const [isShowScrollBtm, setShowScrollBtm] = useState(false);

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
      sendChatMessage(message);
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
          <S.InputCharCount isLimit={values.message.length > MAX_LENGTH}>
            {values.message.length}/{MAX_LENGTH}
          </S.InputCharCount>
        </S.ChatInputContainer>
        <IconButton onClick={handleSendBtn} disabled={!values.message}>
          <S.SendIcon />
        </IconButton>
      </S.ChatInputController>
    </S.ChatRoomContainer>
  );
}

export default ChatRoom;

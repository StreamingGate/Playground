import React from 'react';

import * as S from './ChatRoom.style';
import { useSocket, useForm } from '@utils/hook';

import { Input } from '@components/forms';
import { IconButton } from '@components/buttons';
import { ChatDialog } from '@components/dataDisplays';

function ChatRoom() {
  const { chatData, sendChatMessage } = useSocket('ba59100a-85f7-42dc-8508-0df112a0cf3f');
  const { values, handleInputChange, changeValue } = useForm({ initialValues: { message: '' } });

  const handleSendBtn = e => {
    if (!values.message) {
      return;
    }
    if (e.key === 'Enter' || e.type === 'click') {
      sendChatMessage(values.message);
      changeValue(['message', '']);
    }
  };

  return (
    <S.ChatRoomContainer>
      <S.ChatRoomHeader>
        <S.ChatRoomTitle type='component'>실시간 채팅</S.ChatRoomTitle>
        <S.ChatMetaContainer>
          <S.PersonIcon />
          <S.ChatRoomPeople>6.7천명</S.ChatRoomPeople>
        </S.ChatMetaContainer>
      </S.ChatRoomHeader>
      <S.ChaListContainer>
        {chatData.map(chatInfo => (
          <ChatDialog key={JSON.stringify(chatInfo)} chatInfo={chatInfo} />
        ))}
      </S.ChaListContainer>
      <S.ChatInputContainer>
        <S.UserProfile />
        <Input
          name='message'
          fullWidth
          variant='standard'
          onKeyUp={handleSendBtn}
          placeholder='닉네임으로 채팅하기'
          value={values.message}
          onChange={handleInputChange}
        />
        <IconButton onClick={handleSendBtn} disabled={!values.message}>
          <S.SendIcon />
        </IconButton>
      </S.ChatInputContainer>
    </S.ChatRoomContainer>
  );
}

export default ChatRoom;

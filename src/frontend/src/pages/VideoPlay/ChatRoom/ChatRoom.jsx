import React from 'react';

import * as S from './ChatRoom.style';

import { Input } from '@components/forms';
import { IconButton } from '@components/buttons';
import { ChatDialog, Avatar } from '@components/dataDisplays';

const dummyChatList = [
  { id: 1, timeStamp: '오후 2:30', userName: 'test', message: '이것은 채팅이다.' },
  { id: 2, timeStamp: '오후 2:30', userName: 'test', message: '이것은 채팅이다.' },
  {
    id: 3,
    timeStamp: '오후 2:30',
    userName: 'test',
    message:
      '이것은 채팅이다. 이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.이것은 채팅이다.',
  },
  { id: 4, timeStamp: '오후 2:30', userName: 'test', message: '이것은 채팅이다.' },
  { id: 5, timeStamp: '오후 2:30', userName: 'test', message: '이것은 채팅이다.' },
  { id: 6, timeStamp: '오후 2:30', userName: 'test', message: '이것은 채팅이다.' },
  { id: 7, timeStamp: '오후 2:30', userName: 'test', message: '이것은 채팅이다.' },
  { id: 8, timeStamp: '오후 2:30', userName: 'test', message: '이것은 채팅이다.' },
  { id: 9, timeStamp: '오후 2:30', userName: 'test', message: '이것은 채팅이다.' },
  { id: 10, timeStamp: '오후 2:30', userName: 'test', message: '이것은 채팅이다.' },
  { id: 11, timeStamp: '오후 2:30', userName: 'test', message: '이것은 채팅이다.' },
];

function ChatRoom() {
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
        {dummyChatList.map(chatInfo => (
          <ChatDialog key={chatInfo.id} chatInfo={chatInfo} />
        ))}
      </S.ChaListContainer>
      <S.ChatInputContainer>
        <Avatar />
        <Input fullWidth variant='standard' placeholder='닉네임으로 채팅하기' />
        <IconButton>
          <S.SendIcon />
        </IconButton>
      </S.ChatInputContainer>
    </S.ChatRoomContainer>
  );
}

export default ChatRoom;

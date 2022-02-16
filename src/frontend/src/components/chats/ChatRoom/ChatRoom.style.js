import styled from 'styled-components';

import { Typography, Person, Send, ScrollDown } from '@components/cores';
import { Avatar } from '@components/dataDisplays';

export const ChatRoomContainer = styled.div`
  width: 100%;
  height: 100%;
  border: 1px solid ${({ theme }) => theme.colors.separator};
  --chat-room-header-height: 70px;
  --chat-input-controller-height: 120px;
`;

export const ChatRoomHeader = styled.div`
  display: flex;
  flex-direction: column;
  height: var(--chat-room-header-height);
  padding: 13px 20px;
  background-color: #ffffff;
`;

export const ChatRoomTitle = styled(Typography)``;

export const ChatMetaContainer = styled.div`
  display: flex;
  align-items: center;
  gap: 3px;
`;

export const PersonIcon = styled(Person)`
  width: 14px;
  min-width: 14px;
  height: 14px;
  margin-right: 3px;
`;

export const ChatRoomPeople = styled(Typography)`
  color: ${({ theme }) => theme.colors.customDarkGray};
`;

export const ChaListContainer = styled.ul`
  display: flex;
  flex-direction: column;
  gap: 15px;
  position: relative;
  height: calc(100% - var(--chat-room-header-height) - var(--chat-input-controller-height));
  overflow: auto;
  padding: 20px 20px 15px 20px;
  border-top: 1px solid ${({ theme }) => theme.colors.separator};
  border-bottom: 1px solid ${({ theme }) => theme.colors.separator};
`;

export const pinnedChatContainer = styled.ul`
  position: sticky;
  top: 0px;
  left: 20px;
  right: 20px;
  padding: 10px;
  border-radius: 3px;
  background-color: #ffffff;
`;

export const ScrollDownBtnContainer = styled.div`
  display: flex;
  justify-content: center;
  position: sticky;
  bottom: 5px;
  left: 0;
  right: 0;
`;

export const ScrollDownBtn = styled(ScrollDown)`
  width: 30px;
  height: 30px;
  min-width: none;
  cursor: pointer;
`;

export const ChatInputController = styled.div`
  display: flex;
  align-items: center;
  gap: 10px;
  height: var(--chat-input-controller-height);
  padding: 15px 20px;
  background-color: #ffffff;
`;

export const UserProfile = styled(Avatar)`
  flex-shrink: 0;
`;

export const ChatInputContainer = styled.div`
  width: 90%;
  margin-top: 20px;
  text-align: right;
`;

export const InputCharCount = styled(Typography)`
  color: ${({ theme, isLimit }) => (isLimit ? 'red' : theme.colors.placeHolder)};
`;

export const SendIcon = styled(Send)`
  width: 34px;
  height: 34px;
`;

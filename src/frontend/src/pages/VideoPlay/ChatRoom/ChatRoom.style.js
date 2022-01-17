import styled from 'styled-components';

import { Typography, Person, Send } from '@components/cores';
import { Avatar } from '@components/dataDisplays';

export const ChatRoomContainer = styled.div`
  max-height: 375px;
  margin-bottom: 40px;
`;

export const ChatRoomHeader = styled.div`
  display: flex;
  flex-direction: column;
  padding: 13px 20px;
  background-color: #ffffff;
`;

export const ChatRoomTitle = styled(Typography)`
  font-weight: bold;
`;

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
  height: 240px;
  overflow: auto;
  padding: 20px 20px 0px 20px;
`;

export const ChatInputContainer = styled.div`
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 15px 20px 30px;
  background-color: #ffffff;
`;

export const UserProfile = styled(Avatar)`
  flex-shrink: 0;
`;

export const SendIcon = styled(Send)`
  width: 34px;
  height: 34px;
`;

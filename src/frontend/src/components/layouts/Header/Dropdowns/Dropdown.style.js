import styled from 'styled-components';

import { Logout, Typography } from '@components/cores';
import { Button } from '@components/buttons';
import { Avatar } from '@components/dataDisplays';

export const AlarmDropdownContainer = styled.div`
  position: relative;
  margin-left: -300px;
`;

export const AlarmDropdown = styled.div`
  position: absolute;
  width: 100%;
  background-color: #ffffff;
  box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);
`;

export const AlarmTitle = styled.div`
  padding: 15px;
  border-bottom: 1px solid ${({ theme }) => theme.colors.separator};
`;

export const AlarmBody = styled.div``;

export const AcceptFriendBtnContainer = styled.div`
  padding: 15px 25px 20px;
`;

export const AcceptFriendBtn = styled(Button)`
  width: 100%;
  background-color: ${({ theme }) => theme.colors.pgBlue};
  font-size: ${({ theme }) => theme.fontSizes.content};
  border-radius: 15px;
`;

export const AlarmList = styled.ul`
  height: 350px;
  overflow: auto;
`;

export const AlarmInfo = styled.li`
  display: flex;
  margin: 0px 0px 20px 20px;
  align-items: center;
`;

export const AlarmAvartar = styled(Avatar)`
  flex-shrink: 0;
  margin-right: 10px;
`;

export const AlarmContent = styled(Typography)`
  & > span {
    color: ${({ theme }) => theme.colors.placeHolder};
  }
`;

export const ProfileDropdownContainer = styled.div`
  position: relative;
  margin-left: -300px;
`;

export const ProfileDropdown = styled.div`
  position: absolute;
  width: 100%;
  background-color: #ffffff;
  box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);
  z-index: 1;
`;

export const UserProfileInfo = styled.div`
  display: flex;
  align-items: center;
  padding: 15px;
  border-bottom: 1px solid ${({ theme }) => theme.colors.separator};
`;

export const UserAvartar = styled(Avatar)`
  margin-right: 15px;
`;

export const UserName = styled.div`
  display: flex;
  flex-grow: 1;
  flex-direction: column;
  align-items: flex-start;
`;

export const ModifyUserInfoBtn = styled(Button)`
  color: ${({ theme }) => theme.colors.pgBlue};
  margin-left: -18px;
  font-size: ${({ theme }) => theme.fontSizes.caption};
`;

export const LogoutButton = styled(Button)`
  display: flex;
  color: ${({ theme }) => theme.colors.placeHolder};
  font-size: ${({ theme }) => theme.fontSizes.component};
`;

export const LogoutBtnIcon = styled(Logout)`
  margin-right: 10px;
  & > path {
    stroke: ${({ theme }) => theme.colors.placeHolder};
  }
`;

export const FriendListContainer = styled.div`
  padding: 15px 0px 0px 15px;
`;

export const FriendListTitle = styled(Typography)`
  color: ${({ theme }) => theme.colors.placeHolder};
  margin-bottom: 20px;
`;

export const FriendList = styled.ul`
  height: 270px;
  overflow: auto;
`;

export const FriendInfo = styled.li`
  display: flex;
  align-items: center;
  margin-bottom: 30px;
`;

export const FriendAvatar = styled(Avatar)`
  margin-right: 10px;
`;

export const FriendName = styled(Typography)`
  flex-grow: 1;
`;

export const FriendDeleteBtn = styled(Button)`
  color: ${({ theme }) => theme.colors.pgRed};
  font-size: ${({ theme }) => theme.fontSizes.highlightCaption};
  align-self: flex-end;
`;

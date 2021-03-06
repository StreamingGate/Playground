import styled, { css } from 'styled-components';

import { Typography } from '@components/cores';
import { Button } from '@components/buttons';
import { Avatar } from '@components/dataDisplays';

export const SideFriendListContainer = styled.div`
  position: fixed;
  z-index: 1;
  top: var(--head-height);
  right: 0;
  width: var(--side-friend-list-width);
  height: calc(100vh - var(--head-height));
  padding: 25px 0px 25px 20px;
  background-color: #ffffff;
  overflow: auto;
  transition: visibility 225ms, transform 225ms;
  transition-timing-function: cubic-bezier(0, 0, 0.2, 1);

  ${({ state }) =>
    !state.open &&
    css`
      transform: translateX(var(--side-friend-list-width));
      visibility: hidden;
    `}

  /* BackDrop 컴포넌트와 같이 열릴 때 창 높이를 채움 */
${({ state }) =>
    state.open &&
    state.backdrop &&
    css`
      top: 0;
      bottom: 0;
      height: 100vh;
      z-index: 2;
    `}
`;

export const SideFriendListHeader = styled(Typography)`
  margin-bottom: 15px;
  color: ${({ theme }) => theme.colors.placeHolder};
`;

export const FriendList = styled.ul`
  display: flex;
  flex-direction: column;
  overflow: auto;
  gap: 15px;
`;

export const FriendItem = styled.li`
  display: flex;
  align-items: center;
  cursor: pointer;
`;

export const FriendAvatarContainer = styled.div`
  position: relative;
`;

export const OnlineMark = styled.div`
  width: 8px;
  height: 8px;
  position: absolute;
  right: -2px;
  bottom: 0px;
  background-color: #509752;
  border-radius: 50%;
`;

export const FriendModalContainer = styled.div`
  display: flex;
  position: fixed;
  top: ${({ top }) => `${top}px`};
  width: 230px;
  margin-left: -260px;
  padding: 10px;
  border-radius: 5px;
  box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.25);
  visibility: ${({ isShow }) => (isShow ? 'visible' : 'hidden')};
  background-color: #ffffff;
  z-index: 1;
`;

export const FriendAvatar = styled(Avatar)`
  margin-right: 8px;
`;

export const FriendModalRightDiv = styled.div`
  display: flex;
  flex-direction: column;
`;

export const FriendModalName = styled(Typography)`
  margin-bottom: 2px;
`;

export const FriendVideoName = styled(Typography)`
  margin-bottom: 10px;
  color: ${({ theme }) => theme.colors.customDarkGray};
`;

export const PlayWithFriendBtn = styled(Button)`
  padding: 5px 25px;
  color: #ffffff;
  font-size: ${({ theme }) => theme.fontSizes.highlightCaption};
  background-color: ${({ theme }) => theme.colors.pgBlue};
  border-radius: 12px;
`;

export const FriendName = styled(Typography)`
  margin-left: 5px;
`;

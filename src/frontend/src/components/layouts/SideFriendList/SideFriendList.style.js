import styled, { css } from 'styled-components';

import { Typography } from '@components/cores';

export default {
  SideFriendListContainer: styled.div`
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
  `,
  SideFriendListHeader: styled(Typography)`
    margin-bottom: 15px;
    color: ${({ theme }) => theme.colors.placeHolder};
  `,
  FriendList: styled.ul`
    display: flex;
    flex-direction: column;
    gap: 15px;
  `,
  FriendItem: styled.li`
    display: flex;
    align-items: center;
  `,
  FriendName: styled(Typography)`
    margin-left: 5px;
  `,
};

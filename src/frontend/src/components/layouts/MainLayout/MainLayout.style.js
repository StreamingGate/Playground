import styled, { css } from 'styled-components';

import { breakPoint } from '@utils/constant';

import { Button } from '@components/buttons';

const { queries } = breakPoint;

export default {
  MainContentContainer: styled.main`
    padding-top: var(--head-height);
    margin-left: 0px;
    margin-right: var(--side-friend-list-width);
    height: 100vh;
    overflow: auto;

    ${({ sideNavState }) =>
      sideNavState.open &&
      !sideNavState.backdrop &&
      css`
        margin-left: var(--side-nav-bar-width);
      `}

    @media (${queries.laptopMax}) {
      margin-right: 0;
    }
  `,
  FriendListToggleBtn: styled(Button)`
    display: ${({ isShow }) => (isShow ? 'none' : 'inline')};
    position: fixed;
    bottom: 35px;
    right: 35px;
    padding: 8px;
    background-color: #ffffff;
    border-radius: 100%;
    box-shadow: 0 0 50px rgba(0, 0, 0, 0.25);
  `,
};

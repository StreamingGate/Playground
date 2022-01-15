import styled, { css } from 'styled-components';

import { breakPoint } from '@utils/constant';

import { Button } from '@components/buttons';

const { queries } = breakPoint;

export default {
  MainContentContainer: styled.main`
    margin-left: 250px;
    margin-right: 200px;
    height: calc(100vh - 60px);
    overflow: auto;

    ${({ sideNavState }) =>
      !sideNavState.open &&
      !sideNavState.backdrop &&
      css`
        margin-left: 0;
      `}

    @media (${queries.wideLaptop}) {
      margin-left: 0;
    }

    @media (${queries.laptopMax}) {
      margin-right: 0;
    }
  `,
  FriendListToggleBtn: styled(Button)`
    display: none;
    position: fixed;
    bottom: 35px;
    right: 35px;
    padding: 8px;
    background-color: #ffffff;
    border-radius: 100%;
    box-shadow: 0 0 50px rgba(0, 0, 0, 0.25);

    @media (${queries.laptopMax}) {
      display: inline;
    }
  `,
};

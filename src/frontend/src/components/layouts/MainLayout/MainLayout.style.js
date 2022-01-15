import styled, { css } from 'styled-components';

import { breakPoint } from '@utils/constant';

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
};

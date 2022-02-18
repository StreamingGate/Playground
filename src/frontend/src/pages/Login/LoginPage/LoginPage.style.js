import styled from 'styled-components';

import { breakPoint } from '@utils/constant';

const { queries, screenSize } = breakPoint;

export default {
  LoginPageContainer: styled.main`
    display: flex;
    align-items: center;
    gap: 73px;
    max-width: 764px;
    min-width: ${screenSize.minSize}px;
    height: 100vh;
    margin: 0 auto;
    @media (${queries.tabletMax}) {
      justify-content: center;
    }
  `,
  LoginIntroGif: styled.img`
    width: 400px;
  `,
  OverviewImageContainer: styled.div`
    @media (${queries.tabletMax}) {
      display: none;
    }
  `,
};

import styled, { css } from 'styled-components';

import { breakPoint } from '@utils/constant';

const { queries } = breakPoint;

export const CategorySliderContainer = styled.div`
  position: fixed;
  left: 0;
  right: var(--side-friend-list-width);
  z-index: 1;
  height: 60px;
  padding: 15px 0px;
  background-color: #ffffff;
  border-top: ${({ theme }) => `1px solid ${theme.colors.separator}`};
  border-bottom: ${({ theme }) => `1px solid ${theme.colors.separator}`};

  ${({ sideNavState }) =>
    sideNavState.open &&
    !sideNavState.backdrop &&
    css`
      left: var(--side-nav-bar-width);
    `}

  @media (${queries.laptopMax}) {
    right: 0;
  }
`;

export const CategoryContainer = styled.div`
  display: flex;
  gap: 10px;
  width: 80%;
  margin: 0 auto;
  white-space: nowrap;
  overflow-x: hidden;
`;

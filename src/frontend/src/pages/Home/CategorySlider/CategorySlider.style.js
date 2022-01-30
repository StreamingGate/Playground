import styled, { css } from 'styled-components';

import { breakPoint } from '@utils/constant';

import { ArrowLeft, ArrowRight } from '@components/cores';

const { queries } = breakPoint;

export const CategorySliderContainer = styled.div`
  --category-slider-padding: 15px;
  display: flex;
  align-items: center;
  position: fixed;
  left: 0;
  right: var(--side-friend-list-width);
  z-index: 1;
  height: 60px;
  padding: var(---category-slider-padding) 0px;
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

export const ArrowLeftIcon = styled(ArrowLeft)`
  position: absolute;
  cursor: pointer;
`;

export const ArrowRightIcon = styled(ArrowRight)`
  position: absolute;
  top: var(--category-slider-padding);
  right: 0;
  cursor: pointer;
`;

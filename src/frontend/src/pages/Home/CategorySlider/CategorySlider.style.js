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
  width: 80%;
  margin: 0 auto;
  white-space: nowrap;
  overflow-x: hidden;
`;

export const Categories = styled.div`
  display: flex;
  gap: 10px;
  transition: transform 0.15s cubic-bezier(0.05, 0, 0, 1);
  will-change: transform;
  transform: ${({ xPos }) => `translateX(${xPos}px)`};
`;

export const ArrowLeftIcon = styled(ArrowLeft)``;

export const ArrowRightIcon = styled(ArrowRight)``;

export const LeftArrowButtonContainer = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;
  width: 54px;
  height: 100%;
  position: absolute;
  left: 7%;
  z-index: 1;
  cursor: pointer;
  background: linear-gradient(90deg, #ffffff 76.27%, rgba(255, 255, 255, 0) 100%);
`;

export const RightArrowButtonContainer = styled(LeftArrowButtonContainer)`
  left: auto;
  right: 7%;
  background: linear-gradient(270deg, #ffffff 76.27%, rgba(255, 255, 255, 0) 100%);
`;

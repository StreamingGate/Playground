import { NavLink } from 'react-router-dom';
import styled, { css } from 'styled-components';

import { breakPoint } from '@utils/constant';

const { queries } = breakPoint;

export default {
  Temp: styled.div`
    width: 100vw;
    & > div {
      visibility: hidden;
      transition-property: visibility, opacity;
      transition-duration: 225ms;
      transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
      opacity: 0;

      @media (${queries.wideLaptop}) {
        ${({ isOpen }) =>
          isOpen &&
          css`
            visibility: visible;
            position: fixed;
            width: 100vw;
            height: 100vh;
            opacity: 0.6;
            background-color: ${({ theme }) => theme.colors.customDarkGray};
          `}
      }
    }
  `,
  SideNavigationContainer: styled.nav`
    display: flex;
    flex-direction: column;
    height: calc(100vh - 60px);
    min-width: 250px;
    padding: 5px 10px 0px 0px;
    background-color: #ffffff;
    overflow: auto;
    visibility: visible;
    transition-property: visibility, transform;
    transition-duration: 225ms;
    transition-timing-function: cubic-bezier(0, 0, 0.2, 1);

    ${({ isOpen }) =>
      !isOpen &&
      css`
        transform: translateX(-250px);
        visibility: hidden;
      `}

    @media (${queries.wideLaptop}) {
      transform: translateX(-250px);
      visibility: hidden;

      ${({ isOpen }) =>
        isOpen &&
        css`
          transform: translateX(0);
          visibility: visible;
          position: fixed;
        `}
    }
  `,
  NavigationLink: styled(NavLink)`
    display: flex;
    align-items: center;
    gap: 20px;
    padding: 8px 20px;
    cursor: pointer;
    text-decoration: none;
    color: inherit;

    &:hover {
      background-color: ${({ theme }) => theme.colors.separator};
    }
  `,
  MyNavigationItems: styled.ul`
    padding-top: 11px;
    margin-top: 15px;
    border-top: 1px solid ${({ theme }) => theme.colors.separator};
  `,
};

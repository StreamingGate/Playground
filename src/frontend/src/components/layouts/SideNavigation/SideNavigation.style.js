import { NavLink } from 'react-router-dom';
import styled, { css } from 'styled-components';

import { VerticalLogo } from '@components/cores';

export default {
  SideNavigationContainer: styled.nav`
    display: flex;
    flex-direction: column;
    position: fixed;
    z-index: 2;
    top: var(--head-height);
    height: calc(100vh - var(--head-height));
    width: var(--side-nav-bar-width);
    padding: 5px 10px 0px 0px;
    background-color: #ffffff;
    overflow: auto;
    visibility: visible;
    transition: visibility 225ms, transform 225ms;
    transition-timing-function: cubic-bezier(0, 0, 0.2, 1);

    ${({ state }) =>
      !state.open &&
      css`
        transform: translateX(calc(-1 * var(--side-nav-bar-width)));
        visibility: hidden;
      `}

    /* BackDrop과 함께 열릴 경우 로고와 함께 창 높이를 채움*/
    ${({ state }) =>
      state.open &&
      state.backdrop &&
      css`
        top: 0;
        bottom: 0;
        height: 100vh;
      `}
  `,
  NavigationLogoContainer: styled.div`
    display: flex;
    justify-content: center;
  `,
  NavigationLogo: styled(VerticalLogo)`
    width: 200px;
    height: 50px;
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

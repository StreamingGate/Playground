import { NavLink } from 'react-router-dom';
import styled, { css } from 'styled-components';

export default {
  SideNavigationContainer: styled.nav`
    display: flex;
    flex-direction: column;
    position: fixed;
    height: calc(100vh - 60px);
    min-width: 250px;
    padding: 5px 10px 0px 0px;
    background-color: #ffffff;
    overflow: auto;
    visibility: visible;
    transition: visibility 225ms, transform 225ms;
    transition-timing-function: cubic-bezier(0, 0, 0.2, 1);

    ${({ state }) =>
      !state.open &&
      css`
        transform: translateX(-250px);
        visibility: hidden;
      `}
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

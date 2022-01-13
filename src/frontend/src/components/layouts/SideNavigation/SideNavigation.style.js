import { NavLink } from 'react-router-dom';
import styled from 'styled-components';

import { breakPoint } from '@utils/constant';

const { queries } = breakPoint;

export default {
  SideNavigationContainer: styled.nav`
    display: flex;
    flex-direction: column;
    height: calc(100vh - 60px);
    max-width: 250px;
    padding: 5px 10px 0px 0px;
    background-color: #ffffff;
    overflow: auto;

    @media (max-width: 1000px) {
      max-width: 70px;
    }

    @media (${queries.tabletMax}) {
      display: none;
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

    @media (max-width: 1000px) {
      flex-direction: column;
      gap: 2px;
      padding: 8px;
    }
  `,

  MyNavigationItems: styled.ul`
    padding-top: 11px;
    margin-top: 15px;
    border-top: 1px solid ${({ theme }) => theme.colors.separator};
  `,
};

import styled from 'styled-components';

import { Input } from '@components/forms';
import { Button, IconButton } from '@components/buttons';
import { VerticalLogo } from '@components/cores';
import { Avatar } from '@components/dataDisplays';

import { breakPoint } from '@utils/constant';

const { queries } = breakPoint;

export const Header = styled.header`
  display: flex;
  position: fixed;
  z-index: 2;
  left: 0;
  right: 0;
  align-items: center;
  justify-content: space-between;
  height: var(--head-height);
  background-color: #ffffff;
  padding: 10px 20px;
  min-width: 300px;
`;

export const HeaderLeftDiv = styled.div`
  display: flex;
  align-items: center;
`;

export const HambergurIconButton = styled(IconButton)`
  margin-left: -6px;
  margin-right: 17px;
`;

export const VerticalLogoIcon = styled(VerticalLogo)`
  width: 116px;
  height: 27px;
  min-width: 116px;
  cursor: pointer;
`;

export const SearchContainer = styled.div`
  display: flex;
  align-items: stretch;
  flex-basis: 55%;
  max-width: 1000px;

  @media (${queries.tabletMax}) {
    display: none;
    flex-grow: 1;
  }
`;

export const SearchInput = styled(Input)`
  width: 100%;
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
`;

export const SearchButton = styled(Button)`
  background-color: ${({ theme }) => theme.colors.background};
  border-top-left-radius: 0;
  border-bottom-left-radius: 0;
`;

export const HeaderRightDiv = styled.div`
  display: flex;
  align-items: center;
`;

export const HeaderAvatar = styled(Avatar)`
  margin-left: 8px;
`;

export const SearchBarIconButton = styled(IconButton)`
  display: none;

  @media (${queries.tabletMax}) {
    display: revert;
  }
`;

export const SearchBarAvatar = styled(Avatar)`
  margin-left: 25px;
`;

import styled from 'styled-components';

import { Input } from '@components/forms';
import { Button, IconButton } from '@components/buttons';
import { VerticalLogo, Logout, Typography } from '@components/cores';
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

export const AddVideoDropdownContainer = styled.div`
  position: relative;
  top: 0;
  margin-left: -200px; ;
`;

export const AddVideoMenus = styled.ul`
  position: absolute;
  width: 100%;
  background-color: #ffffff;
  padding: 9px;
  box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);
`;

export const AddVideoMenu = styled.li`
  display: flex;
  gap: 15px;
  padding: 8px 4px;
  cursor: pointer;
  &:hover {
    background-color: ${({ theme }) => theme.colors.background};
  }
`;

export const ProfileDropdownContainer = styled.div`
  position: relative;
  margin-left: -300px;
`;

export const ProfileDropdown = styled.div`
  position: absolute;
  width: 100%;
  background-color: #ffffff;
  box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);
`;

export const UserProfileInfo = styled.div`
  display: flex;
  align-items: center;
  padding: 15px;
  border-bottom: 1px solid ${({ theme }) => theme.colors.separator};
`;

export const UserAvartar = styled(Avatar)`
  margin-right: 15px;
`;

export const UserName = styled.div`
  display: flex;
  flex-grow: 1;
  flex-direction: column;
  align-items: flex-start;
`;

export const ModifyUserInfoBtn = styled(Button)`
  color: ${({ theme }) => theme.colors.pgBlue};
  margin-left: -18px;
`;

export const LogoutButtonContainer = styled(Button)`
  display: flex;
  color: ${({ theme }) => theme.colors.placeHolder};
`;

export const LogoutBtnIcon = styled(Logout)`
  margin-right: 10px;
  & > path {
    stroke: ${({ theme }) => theme.colors.placeHolder};
  }
`;

export const SearchBarAvatar = styled(Avatar)`
  margin-left: 25px;
`;

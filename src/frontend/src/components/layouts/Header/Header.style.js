import styled from 'styled-components';

import { Input } from '@components/forms';
import { Button, IconButton } from '@components/buttons';
import { VerticalLogo, Typography } from '@components/cores';
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
  z-index: 1;
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

export const AlarmDropdownContainer = styled.div`
  position: relative;
  margin-left: -300px;
`;

export const AlarmDropdown = styled.div`
  position: absolute;
  width: 100%;
  background-color: #ffffff;
  box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);
`;

export const AlarmTitle = styled.div`
  padding: 15px;
  border-bottom: 1px solid ${({ theme }) => theme.colors.separator};
`;

export const AlarmBody = styled.div`
  padding: 15px 25px 0px;
`;

export const AcceptFriendBtn = styled(Button)`
  width: 100%;
  background-color: ${({ theme }) => theme.colors.pgBlue};
  font-size: ${({ theme }) => theme.fontSizes.content};
  border-radius: 15px;
`;

export const AlarmList = styled.ul`
  margin-top: 30px;
  height: 350px;
  overflow: auto;
`;

export const AlarmInfo = styled.li`
  display: flex;
  align-items: center;
  &:not(:last-child) {
    margin-bottom: 30px;
  }
`;

export const AlarmAvartar = styled(Avatar)`
  flex-shrink: 0;
  margin-right: 10px;
`;

export const AlarmContent = styled(Typography)`
  & > span {
    color: ${({ theme }) => theme.colors.placeHolder};
  }
`;

export const SearchBarAvatar = styled(Avatar)`
  margin-left: 25px;
`;

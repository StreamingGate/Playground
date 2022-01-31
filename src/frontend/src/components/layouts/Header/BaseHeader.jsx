import React, { useContext, useState } from 'react';

import * as S from './Header.style';
import { HeaderContext, MainLayoutContext } from '@utils/context';

import { IconButton } from '@components/buttons';
import {
  Typography,
  HamburgerBar,
  AddEmptyCircle,
  AddFullCircle,
  Alarm,
  Search,
  MyVideo,
  LiveStreaming,
  Logout,
} from '@components/cores';
import SearchForm from './SearchForm';

function BaseHeader() {
  const { onToggle } = useContext(HeaderContext);
  const { onToggleSideNav } = useContext(MainLayoutContext);

  const [isAddButtonToggle, setAddButtonToggle] = useState(false);
  const [isProfileBtnToggle, setProfileBtnToggle] = useState(false);

  const handleAddButtonToggle = () => {
    setAddButtonToggle(prev => !prev);
  };

  return (
    <>
      <S.HeaderLeftDiv>
        <S.HambergurIconButton onClick={onToggleSideNav}>
          <HamburgerBar />
        </S.HambergurIconButton>
        <S.VerticalLogoIcon />
      </S.HeaderLeftDiv>
      <SearchForm />
      <S.HeaderRightDiv>
        <S.SearchBarIconButton onClick={onToggle}>
          <Search />
        </S.SearchBarIconButton>
        <div>
          <IconButton onClick={handleAddButtonToggle}>
            {isAddButtonToggle ? <AddFullCircle /> : <AddEmptyCircle />}
          </IconButton>
          <S.AddVideoDropdownContainer>
            {isAddButtonToggle && (
              <S.AddVideoMenus>
                <S.AddVideoMenu>
                  <MyVideo />
                  <Typography type='component'>동영상 업로드</Typography>
                </S.AddVideoMenu>
                <S.AddVideoMenu>
                  <LiveStreaming />
                  <Typography type='component'>실시간 스트리밍 시작</Typography>
                </S.AddVideoMenu>
              </S.AddVideoMenus>
            )}
          </S.AddVideoDropdownContainer>
        </div>
        <div>
          <IconButton>
            <Alarm />
          </IconButton>
        </div>
        <div>
          <S.HeaderAvatar />
          <S.ProfileDropdownContainer>
            <S.ProfileDropdown>
              <S.UserProfileInfo>
                <S.UserAvartar size='xl' />
                <S.UserName>
                  <Typography type='content'>닉네임</Typography>
                  <S.ModifyUserInfoBtn variant='text'>
                    <Typography type='caption'>정보 수정</Typography>
                  </S.ModifyUserInfoBtn>
                </S.UserName>
                <S.LogoutButtonContainer variant='text'>
                  <S.LogoutBtnIcon />
                  <Typography type='component'>로그아웃</Typography>
                </S.LogoutButtonContainer>
              </S.UserProfileInfo>
            </S.ProfileDropdown>
          </S.ProfileDropdownContainer>
        </div>
      </S.HeaderRightDiv>
    </>
  );
}

export default BaseHeader;

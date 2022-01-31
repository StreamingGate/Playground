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
} from '@components/cores';
import SearchForm from './SearchForm';

const dummyFriends = [
  { id: 1, name: '김하늬' },
  { id: 2, name: '서채희' },
  { id: 3, name: '이우재' },
  { id: 4, name: '이이경' },
  { id: 5, name: '이수현' },
  { id: 6, name: 'Daniel Radcliffe' },
  { id: 7, name: 'Emma Watson' },
];

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
                  <S.ModifyUserInfoBtn variant='text'>정보 수정</S.ModifyUserInfoBtn>
                </S.UserName>
                <S.LogoutButton variant='text'>
                  <S.LogoutBtnIcon />
                  로그아웃
                </S.LogoutButton>
              </S.UserProfileInfo>
              <S.FriendListContainer>
                <S.FriendListTitle type='highlightCaption'>친구목록</S.FriendListTitle>
                <S.FriendList>
                  {dummyFriends.map(({ id, name }) => (
                    <S.FriendInfo key={id}>
                      <S.FriendAvatar tyep='sm' />
                      <S.FriendName type='caption'>{name}</S.FriendName>
                      <S.FriendDeleteBtn variant='text'>삭제</S.FriendDeleteBtn>
                    </S.FriendInfo>
                  ))}
                </S.FriendList>
              </S.FriendListContainer>
            </S.ProfileDropdown>
          </S.ProfileDropdownContainer>
        </div>
      </S.HeaderRightDiv>
    </>
  );
}

export default BaseHeader;

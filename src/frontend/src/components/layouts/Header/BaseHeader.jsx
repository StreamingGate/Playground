import React, { useEffect, useContext, useState } from 'react';

import * as S from './Header.style';
import { HeaderContext, MainLayoutContext } from '@utils/context';

import { IconButton } from '@components/buttons';
import { BackDrop } from '@components/feedbacks';
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

  const [toggleState, setToggleState] = useState({ addVideo: false, profile: false });

  const handleAllModalClose = () => {
    setToggleState({ profile: false, addVideo: false });
  };

  useEffect(() => {
    if (toggleState.addVideo || toggleState.profile) {
      window.addEventListener('click', handleAllModalClose);
    }
    return () => {
      window.removeEventListener('click', handleAllModalClose);
    };
  }, [toggleState]);

  const handleAddButtonToggle = () => {
    setToggleState(prev => ({ profile: false, addVideo: !prev.addVideo }));
  };

  const handleProfileBtnToggle = () => {
    setToggleState(prev => ({ addVideo: false, profile: !prev.profile }));
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
            {toggleState.addVideo ? <AddFullCircle /> : <AddEmptyCircle />}
          </IconButton>
          <S.AddVideoDropdownContainer>
            {toggleState.addVideo && (
              <>
                {/* <BackDrop
                  isOpen={toggleState.addVideo}
                  backgroundColor='rgba(255, 255, 255, 0)'
                  onClick={handleAddButtonToggle}
                /> */}
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
              </>
            )}
          </S.AddVideoDropdownContainer>
        </div>
        <div>
          <IconButton>
            <Alarm />
          </IconButton>
        </div>
        <div>
          <S.HeaderAvatar onClick={handleProfileBtnToggle} />
          <S.ProfileDropdownContainer>
            {toggleState.profile && (
              <>
                {/* <BackDrop
                  isOpen={toggleState.profile}
                  backgroundColor='rgba(255, 255, 255, 0)'
                  onClick={handleProfileBtnToggle}
                /> */}
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
              </>
            )}
          </S.ProfileDropdownContainer>
        </div>
      </S.HeaderRightDiv>
    </>
  );
}

export default BaseHeader;

import React, { useEffect, useContext, useState } from 'react';

import * as S from './Header.style';
import { modalService } from '@utils/service';
import { HeaderContext, MainLayoutContext } from '@utils/context';

import { IconButton } from '@components/buttons';
import {
  Typography,
  HamburgerBar,
  AddEmptyCircle,
  AddFullCircle,
  FullAlarm,
  Alarm,
  Search,
  MyVideo,
  LiveStreaming,
} from '@components/cores';
import { AcceptFriendModal, DeleteFriendModal } from '@components/feedbacks/Modals';
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

const dummyAlarms = [
  { id: 1, content: '김하늬님이 라이브 방송을 시작하셨습니다', time: '지금' },
  { id: 2, content: '서채희님이 회원님의 비디오에 댓글을 남겼습니다', time: '1일' },
  { id: 3, content: '이우재님이 회원님께 친구를 요청하셨습니다', time: '4일' },
];

function BaseHeader() {
  const { onToggle } = useContext(HeaderContext);
  const { onToggleSideNav, modalState, onToggleModal } = useContext(MainLayoutContext);

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

  const handleAddVideoModalClick = e => {
    e.stopPropagation();
  };

  const handleAlarmModalClick = e => {
    e.stopPropagation();
    const { target } = e;
    if (target.tagName === 'BUTTON') {
      modalService.show(AcceptFriendModal);
    }
  };

  const handleProfileModalClick = e => {
    e.stopPropagation();
    const { target } = e;
    const button = target.closest('button');

    if (!button) return;
    const [buttonId, friendIdx] = button.id.split('_');

    if (buttonId === 'friendDelete') {
      const seletedName = dummyFriends[Number(friendIdx)].name;
      modalService.show(DeleteFriendModal, { friendName: seletedName });
    }
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
          <IconButton name='addVideo' onClick={onToggleModal}>
            {modalState.addVideo ? <AddFullCircle /> : <AddEmptyCircle />}
          </IconButton>
          <S.AddVideoDropdownContainer onClick={handleAddVideoModalClick}>
            {modalState.addVideo && (
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
          <IconButton name='alarm' onClick={onToggleModal}>
            {modalState.alarm ? <FullAlarm /> : <Alarm />}
          </IconButton>
          <S.AlarmDropdownContainer onClick={handleAlarmModalClick}>
            {modalState.alarm && (
              <S.AlarmDropdown>
                <S.AlarmTitle>
                  <Typography>알림</Typography>
                </S.AlarmTitle>
                <S.AlarmBody>
                  <S.AcceptFriendBtn>친구 요청</S.AcceptFriendBtn>
                  <S.AlarmList>
                    {dummyAlarms.map(alarm => (
                      <S.AlarmInfo key={alarm.id}>
                        <S.AlarmAvartar size='sm' />
                        <S.AlarmContent type='caption'>
                          {alarm.content} <span>{alarm.time}</span>
                        </S.AlarmContent>
                      </S.AlarmInfo>
                    ))}
                  </S.AlarmList>
                </S.AlarmBody>
              </S.AlarmDropdown>
            )}
          </S.AlarmDropdownContainer>
        </div>
        <div>
          <S.HeaderAvatar name='profile' onClick={onToggleModal} />
          <S.ProfileDropdownContainer onClick={handleProfileModalClick}>
            {modalState.profile && (
              <S.ProfileDropdown>
                <S.UserProfileInfo>
                  <S.UserAvartar size='xl' />
                  <S.UserName>
                    <Typography type='content'>닉네임</Typography>
                    <S.ModifyUserInfoBtn variant='text' id='modifyProfile'>
                      정보 수정
                    </S.ModifyUserInfoBtn>
                  </S.UserName>
                  <S.LogoutButton variant='text' id='logout'>
                    <S.LogoutBtnIcon />
                    로그아웃
                  </S.LogoutButton>
                </S.UserProfileInfo>
                <S.FriendListContainer>
                  <S.FriendListTitle type='highlightCaption'>친구목록</S.FriendListTitle>
                  <S.FriendList>
                    {dummyFriends.map(({ id, name }, idx) => (
                      <S.FriendInfo key={id}>
                        <S.FriendAvatar tyep='sm' />
                        <S.FriendName type='caption'>{name}</S.FriendName>
                        <S.FriendDeleteBtn id={`friendDelete_${idx}`} variant='text'>
                          삭제
                        </S.FriendDeleteBtn>
                      </S.FriendInfo>
                    ))}
                  </S.FriendList>
                </S.FriendListContainer>
              </S.ProfileDropdown>
            )}
          </S.ProfileDropdownContainer>
        </div>
      </S.HeaderRightDiv>
    </>
  );
}

export default BaseHeader;

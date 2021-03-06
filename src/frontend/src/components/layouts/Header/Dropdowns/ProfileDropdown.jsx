import React, { useContext } from 'react';
import { useNavigate } from 'react-router-dom';

import * as S from './Dropdown.style';
import { modalService, lStorageService } from '@utils/service';
import { MainLayoutContext } from '@utils/context';
import { useStatusSocket } from '@utils/hook';
import { useFriendList } from '@utils/hook/query';

import { Typography } from '@components/cores';
import { DeleteFriendModal, ModifyProfileModal } from '@components/feedbacks/Modals';

function ProfileDropdown() {
  const userId = lStorageService.getItem('uuid');
  const nickName = lStorageService.getItem('nickName');

  const { modalState } = useContext(MainLayoutContext);
  const { data: friendList } = useFriendList(userId);

  const navigate = useNavigate();

  const { stompClient } = useStatusSocket();

  const handleProfileModalClick = e => {
    e.stopPropagation();
    const { target } = e;
    const button = target.closest('button');

    if (!button) return;
    const [buttonId, uuid, nickname] = button.id.split('_');

    if (buttonId === 'friendDelete') {
      modalService.show(DeleteFriendModal, {
        friendName: nickname,
        target: uuid,
        myId: userId,
      });
    } else if (buttonId === 'modifyProfile') {
      modalService.show(ModifyProfileModal, { nickName });
    } else if (buttonId === 'logout') {
      lStorageService.removeItem('nickName');
      lStorageService.removeItem('profileImage');
      lStorageService.removeItem('uuid');
      lStorageService.removeItem('token');
      stompClient.deactivate();
      navigate('/login');
    }
  };

  return (
    <S.ProfileDropdownContainer onClick={handleProfileModalClick}>
      {modalState.profile && (
        <S.ProfileDropdown>
          <S.UserProfileInfo>
            <S.UserAvartar size='xl' imgSrc={`${process.env.REACT_APP_PROFILE_IMAGE}${userId}`} />
            <S.UserName>
              <Typography type='content'>{nickName}</Typography>
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
              {friendList?.result.map(({ uuid, nickname }) => (
                <S.FriendInfo key={uuid}>
                  <S.FriendAvatar
                    tyep='sm'
                    imgSrc={`${process.env.REACT_APP_PROFILE_IMAGE}${uuid}`}
                  />
                  <S.FriendName type='caption'>{nickname}</S.FriendName>
                  <S.FriendDeleteBtn id={`friendDelete_${uuid}_${nickname}`} variant='text'>
                    삭제
                  </S.FriendDeleteBtn>
                </S.FriendInfo>
              ))}
            </S.FriendList>
          </S.FriendListContainer>
        </S.ProfileDropdown>
      )}
    </S.ProfileDropdownContainer>
  );
}

export default ProfileDropdown;

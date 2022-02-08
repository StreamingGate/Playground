import React, { useContext } from 'react';

import * as S from './Dropdown.style';
import { modalService } from '@utils/service';
import { MainLayoutContext } from '@utils/context';
import { useFriendList } from '@utils/hook/query';

import { Typography } from '@components/cores';
import { DeleteFriendModal, ModifyProfileModal } from '@components/feedbacks/Modals';

function ProfileDropdown() {
  const { modalState } = useContext(MainLayoutContext);
  const { data: friendList } = useFriendList('33333333-1234-1234-123456789012');

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
        myId: '33333333-1234-1234-123456789012',
      });
    } else if (buttonId === 'modifyProfile') {
      modalService.show(ModifyProfileModal, { nickName: '이재윤' });
    }
  };

  return (
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
              {friendList?.result.map(({ uuid, nickname, profileImage }) => (
                <S.FriendInfo key={uuid}>
                  <S.FriendAvatar tyep='sm' imgSrc={profileImage} />
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

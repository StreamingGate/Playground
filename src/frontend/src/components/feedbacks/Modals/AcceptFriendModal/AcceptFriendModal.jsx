import React from 'react';
import PropTypes from 'prop-types';

import * as S from './AcceptFriendModal.style';
import { modalService } from '@utils/service';

import { Dialog } from '@components/feedbacks';
import { Avatar } from '@components/dataDisplays';
import { Typography } from '@components/cores';

function AcceptFriendModal({ friendReqList }) {
  const modal = modalService.useModal();

  const handleAcceptFriendModalClose = e => {
    e.stopPropagation();
    modal.hide();
  };

  return (
    <Dialog open={modal.visible} zIndex={2} onClose={handleAcceptFriendModalClose}>
      <S.AcceptFriendModalContainer onClick={e => e.stopPropagation()}>
        <S.AcceptFriendModalTitle>
          <Typography type='subtitle'>친구 요청</Typography>
        </S.AcceptFriendModalTitle>
        <S.AcceptFriendModalBody>
          <S.AcceptFriendList>
            {friendReqList?.result.map(({ uuid, nickname, profileImage }) => (
              <S.AcceptFriend key={uuid}>
                <Avatar size='sm' imgSrc={profileImage} />
                <Typography type='caption'>{nickname}</Typography>
                <S.ActionContainer>
                  <S.AcceptButton size='sm' color='pgBlue'>
                    수락
                  </S.AcceptButton>
                  <S.DeclineButton size='sm'>거절</S.DeclineButton>
                </S.ActionContainer>
              </S.AcceptFriend>
            ))}
          </S.AcceptFriendList>
          <S.CloseButtonContainer>
            <S.CloseButton onClick={handleAcceptFriendModalClose}>닫기</S.CloseButton>
          </S.CloseButtonContainer>
        </S.AcceptFriendModalBody>
      </S.AcceptFriendModalContainer>
    </Dialog>
  );
}

AcceptFriendModal.propTypes = {
  friendReqList: PropTypes.object.isRequired,
};

export default modalService.create(AcceptFriendModal);

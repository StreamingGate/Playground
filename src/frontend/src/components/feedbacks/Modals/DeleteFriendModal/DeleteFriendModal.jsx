import React from 'react';
import PropTypes from 'prop-types';

import * as S from './DeleteFriendModal.style';
import { modalService } from '@utils/service';
import { useDeleteFriend } from '@utils/hook/query';

import { Dialog } from '@components/feedbacks';
import { Avatar } from '@components/dataDisplays';
import { Typography } from '@components/cores';

function DeleteFriendModal({ friendName, target, myId }) {
  const modal = modalService.useModal();
  const { mutate } = useDeleteFriend();

  const handleCloseBtnClose = () => {
    modal.hide();
  };

  const handleDeleteBtnClick = () => {
    mutate({ target, myId });
    modal.hide();
  };

  return (
    <Dialog open={modal.visible} zIndex={2} onClose={handleCloseBtnClose}>
      <S.DeleteFriendModalContainer onClick={e => e.stopPropagation()}>
        <S.DeleteFriendModalTitle>
          <Typography type='subtitle'>친구 삭제</Typography>
        </S.DeleteFriendModalTitle>
        <S.DeleteFriendModalBody>
          <S.DeleteFriendInfoContainer>
            <Avatar size='lg' imgSrc={`${process.env.REACT_APP_PROFILE_IMAGE}${target}`} />
            <Typography>{friendName}</Typography>
          </S.DeleteFriendInfoContainer>
          <Typography>
            위 친구를 삭제하시겠습니까? <br />
            해당 동작은 취소할 수 없으며 친구를 삭제하시면 상대방의 친구목록에서 본 계정이
            삭제됩니다.
          </Typography>
          <S.ActionContainer>
            <S.CloseButton onClick={handleCloseBtnClose}>취소</S.CloseButton>
            <S.DeleteButton color='pgRed' onClick={handleDeleteBtnClick}>
              삭제
            </S.DeleteButton>
          </S.ActionContainer>
        </S.DeleteFriendModalBody>
      </S.DeleteFriendModalContainer>
    </Dialog>
  );
}

DeleteFriendModal.propTypes = {
  friendName: PropTypes.string.isRequired,
  target: PropTypes.string.isRequired,
  myId: PropTypes.string.isRequired,
};

export default modalService.create(DeleteFriendModal);

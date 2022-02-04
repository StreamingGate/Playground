import React from 'react';
import PropTypes from 'prop-types';

import * as S from './AcceptFriendModal.style';
import { modalService } from '@utils/service';
import { useHandleFriendReq, useGetFriendReqList } from '@utils/hook/query';

import { Dialog } from '@components/feedbacks';
import { Avatar } from '@components/dataDisplays';
import { Typography } from '@components/cores';

function AcceptFriendModal({ myId }) {
  const modal = modalService.useModal();

  const { data: friendReqList } = useGetFriendReqList(myId);
  const { mutate } = useHandleFriendReq();

  const handleAcceptFriendModalClose = e => {
    e.stopPropagation();
    modal.hide();
  };

  const handleReqActionBtnClick = friendUuid => e => {
    const { target } = e;
    if (target.id === 'accept') {
      mutate({ type: 'accept', target: friendUuid, myId });
    } else if (target.id === 'decline') {
      mutate({ type: 'decline', target: friendUuid, myId });
    }
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
                <S.ActionContainer onClick={handleReqActionBtnClick(uuid)}>
                  <S.AcceptButton id='accept' size='sm' color='pgBlue'>
                    수락
                  </S.AcceptButton>
                  <S.DeclineButton id='decline' size='sm'>
                    거절
                  </S.DeclineButton>
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
  myId: PropTypes.string.isRequired,
};

export default modalService.create(AcceptFriendModal);

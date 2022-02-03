import React from 'react';

import * as S from './AcceptFriendModal.style';
import { modalService } from '@utils/service';

import { Dialog } from '@components/feedbacks';
import { Avatar } from '@components/dataDisplays';
import { Typography } from '@components/cores';

const dummyFriend = [
  { id: 1, friendName: '김하늬' },
  { id: 2, friendName: '서채희' },
  { id: 3, friendName: '이우재' },
  { id: 4, friendName: 'A' },
  { id: 5, friendName: 'B' },
  { id: 6, friendName: 'C' },
];

function AcceptFriendModal() {
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
            {dummyFriend.map(({ id, friendName }) => (
              <S.AcceptFriend key={id}>
                <Avatar size='sm' />
                <Typography type='caption'>{friendName}</Typography>
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

export default modalService.create(AcceptFriendModal);

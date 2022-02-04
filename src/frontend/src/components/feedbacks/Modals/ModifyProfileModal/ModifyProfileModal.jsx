import React from 'react';

import * as S from './ModifyProfileModal.style';
import { modalService } from '@utils/service';

import { Dialog } from '@components/feedbacks';
import { Typography } from '@components/cores';
import { Input } from '@components/forms';

function ModifyProfileModal() {
  const modal = modalService.useModal();

  const handleModifyProfileModalClose = e => {
    e.stopPropagation();
    modal.hide();
  };

  return (
    <Dialog open={modal.visible} zIndex={2} onClose={handleModifyProfileModalClose}>
      <S.ModifyProfileModalContainer onClick={e => e.stopPropagation()}>
        <S.ModifyProfileModalTitle>
          <Typography type='subtitle'>계정 정보 수정</Typography>
        </S.ModifyProfileModalTitle>
        <S.ModifyProfileModalBody>
          <S.UserProfileContainer>
            <S.UserProfile>
              <img alt='carmera' />
            </S.UserProfile>
          </S.UserProfileContainer>
          <S.InputLabel type='caption'>닉네임</S.InputLabel>
          <Input name='profile' fullWidth variant='standard' />
          <S.ActionContainer>
            <S.CloseButton onClick={handleModifyProfileModalClose}>취소</S.CloseButton>
            <S.ModifyButton>수정</S.ModifyButton>
          </S.ActionContainer>
        </S.ModifyProfileModalBody>
      </S.ModifyProfileModalContainer>
    </Dialog>
  );
}

export default modalService.create(ModifyProfileModal);

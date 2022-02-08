import React, { useRef } from 'react';

import * as S from './ModifyProfileModal.style';
import { modalService } from '@utils/service';
import { validation } from '@utils/constant';
import { useForm } from '@utils/hook';

import { Dialog } from '@components/feedbacks';
import { Typography } from '@components/cores';
import { Input } from '@components/forms';

function ModifyProfileModal({ nickName }) {
  const modal = modalService.useModal();
  const profileInputRef = useRef(null);

  const { values, errors, touched, handleInputChange, handleInputBlur, handleSubmit } = useForm({
    initialValues: { nickName },
    validSchema: validation.modifyProfile,
  });

  const handleModifyProfileModalClose = e => {
    e.stopPropagation();
    modal.hide();
  };

  const handleProfileSelectBtnClick = () => {
    profileInputRef.current.click();
  };

  return (
    <Dialog open={modal.visible} zIndex={2} onClose={handleModifyProfileModalClose}>
      <S.ModifyProfileModalContainer onClick={e => e.stopPropagation()}>
        <S.ModifyProfileModalTitle>
          <Typography type='subtitle'>계정 정보 수정</Typography>
        </S.ModifyProfileModalTitle>
        <S.ModifyProfileModalBody>
          <S.UserProfileContainer onClick={handleProfileSelectBtnClick}>
            <S.UserProfile>
              <img alt='carmera' />
            </S.UserProfile>
            <div style={{ display: 'none' }}>
              <Input type='file' accept='.jpg, .jpeg, .png' ref={profileInputRef} />
            </div>
          </S.UserProfileContainer>
          <S.InputLabel type='caption'>닉네임</S.InputLabel>
          <S.ProfileInput
            name='nickName'
            fullWidth
            variant='standard'
            value={values.nickName}
            onChange={handleInputChange}
            onBlur={handleInputBlur}
            error={!!(touched.nickName && errors.nickName)}
            helperText={errors.nickName}
          />
          <S.ActionContainer>
            <S.CloseButton onClick={handleModifyProfileModalClose}>취소</S.CloseButton>
            <S.ModifyButton onClick={handleSubmit}>수정</S.ModifyButton>
          </S.ActionContainer>
        </S.ModifyProfileModalBody>
      </S.ModifyProfileModalContainer>
    </Dialog>
  );
}

export default modalService.create(ModifyProfileModal);

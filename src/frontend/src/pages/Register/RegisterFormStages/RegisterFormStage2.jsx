import React, { useEffect, useRef } from 'react';
import PropTypes from 'prop-types';

import * as S from './RegisterFormStages.style';
import { theme } from '@utils/constant';
import { mediaService } from '@utils/service';

import { Typography } from '@components/cores';

/**
 *
 * @returns {React.Component} 두 번째 회원가입 폼
 */

function RegisterFormStage2({ values, errors, touched, onChange, onProfileChange, onBlur }) {
  const { name, nickName, profileImage } = values;

  const defaultProfileImg = useRef('');
  const profileInputRef = useRef(null);

  useEffect(() => {
    defaultProfileImg.current = mediaService.createImageFromInitials(name);
    onProfileChange(defaultProfileImg.current);
  }, []);

  const handleProfileSelectBtnClick = () => {
    profileInputRef.current.click();
  };

  // 기본 프로필 이미지로 변경해주는 함수
  const handleResetProfileBtnClick = () => {
    profileInputRef.current.value = '';
    onProfileChange(defaultProfileImg.current);
  };

  // 선택한 이미지를 data url로 변경해 미리보기 형식으로 그려주는 함수
  const handleProfileInputChange = async () => {
    const dataUrl = await mediaService.getImagePreviewURl(profileInputRef.current);
    onProfileChange(dataUrl);
  };

  return (
    <>
      <S.FormStageInputContainer>
        <S.InputLabel>프로필</S.InputLabel>
        <S.ProfilInputContainer>
          <S.ProfilePreview src={profileImage} />
          <S.ProfileInput
            type='file'
            accept='.jpg, .jpeg, .png'
            ref={profileInputRef}
            onChange={handleProfileInputChange}
          />
          <S.ProfileActionContainer>
            <S.FileSelectBtn color='pgBlue' onClick={handleProfileSelectBtnClick}>
              <Typography>파일에서 선택</Typography>
            </S.FileSelectBtn>
            <S.DefaultProfileBtn variant='outlined' onClick={handleResetProfileBtnClick}>
              <S.DefaultProfileBtnContent>기본이미지로 변경</S.DefaultProfileBtnContent>
            </S.DefaultProfileBtn>
          </S.ProfileActionContainer>
        </S.ProfilInputContainer>
      </S.FormStageInputContainer>
      <S.FormStageInputContainer>
        <S.InputLabel>닉네임</S.InputLabel>
        <S.StageInput
          name='nickName'
          size='sm'
          fullWidth
          value={nickName}
          onChange={onChange}
          onBlur={onBlur}
          error={!!(touched.nickName && errors.nickName)}
          helperText={errors.nickName}
        />
      </S.FormStageInputContainer>
    </>
  );
}

RegisterFormStage2.propTypes = {
  values: PropTypes.shape({
    profileImage: PropTypes.string,
    nickName: PropTypes.string,
  }).isRequired,
  errors: PropTypes.object.isRequired,
  touched: PropTypes.object.isRequired,
  onChange: PropTypes.func.isRequired,
  onBlur: PropTypes.func.isRequired,
  onProfileChange: PropTypes.func.isRequired,
};

export default RegisterFormStage2;

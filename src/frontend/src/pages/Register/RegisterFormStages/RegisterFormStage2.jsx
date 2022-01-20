import React, { useEffect, useRef, useState } from 'react';

import * as S from './RegisterFormStages.style';
import { theme } from '@utils/constant';
import { mediaService } from '@utils/service';

import { Typography } from '@components/cores';

function RegisterFormStage2() {
  const defaultProfileImg = useRef('');
  const profileInputRef = useRef(null);

  const [imageUrl, setImageUrl] = useState('');

  useEffect(() => {
    defaultProfileImg.current = mediaService.createImageFromInitials(
      'Alpha',
      theme.colors.pgOrange,
      '#ffffff'
    );
    setImageUrl(defaultProfileImg.current);
  }, []);

  const handleProfileSelectBtn = () => {
    profileInputRef.current.click();
  };

  const handleProfileInput = async () => {
    const dataUrl = await mediaService.getImagePreviewURl(profileInputRef.current);
    setImageUrl(dataUrl);
  };

  const handleResetProfileBtn = () => {
    setImageUrl(defaultProfileImg.current);
  };

  return (
    <>
      <S.FormStageInputContainer>
        <S.InputLabel>프로필</S.InputLabel>
        <S.ProfilInputContainer>
          <S.ProfilePreview src={imageUrl} />
          <S.ProfileInput type='file' ref={profileInputRef} onChange={handleProfileInput} />
          <S.ProfileActionContainer>
            <S.FileSelectBtn color='pgBlue' onClick={handleProfileSelectBtn}>
              <Typography>파일에서 선택</Typography>
            </S.FileSelectBtn>
            <S.DefaultProfileBtn variant='outlined' onClick={handleResetProfileBtn}>
              <S.DefaultProfileBtnContent>기본이미지로 변경</S.DefaultProfileBtnContent>
            </S.DefaultProfileBtn>
          </S.ProfileActionContainer>
        </S.ProfilInputContainer>
      </S.FormStageInputContainer>
      <S.FormStageInputContainer>
        <S.InputLabel>닉네임</S.InputLabel>
        <S.StageInput size='sm' fullWidth />
      </S.FormStageInputContainer>
    </>
  );
}

export default RegisterFormStage2;

import React, { useState, memo } from 'react';

import * as S from './RegisterFormStages.style';

import { Button } from '@components/buttons';

function RegisterFormStage1() {
  const [isVerify, setIsVerify] = useState(false);

  const handleVerifyBtnClick = () => {
    setIsVerify(true);
  };

  return (
    <>
      <S.FormStageInputContainer>
        <S.InputLabel>이름</S.InputLabel>
        <S.StageInput size='sm' fullWidth />
      </S.FormStageInputContainer>
      <S.FormStageInputContainer>
        <S.InputLabel>이메일</S.InputLabel>
        <S.StageInput size='sm' fullWidth />
      </S.FormStageInputContainer>
      {!isVerify ? (
        <S.VerifyButtonContainer>
          <Button color='pgBlue' onClick={handleVerifyBtnClick}>
            인증하기
          </Button>
        </S.VerifyButtonContainer>
      ) : (
        <S.FormStageInputContainer>
          <S.InputLabel>이메일 인증</S.InputLabel>
          <S.StageInput size='sm' fullWidth />
        </S.FormStageInputContainer>
      )}
    </>
  );
}

export default memo(RegisterFormStage1);

import React from 'react';

import * as S from './RegisterFormStages.style';

function RegisterFormState3() {
  return (
    <>
      <S.FormStageInputContainer>
        <S.InputLabel>비밀번호</S.InputLabel>
        <S.StageInput type='password' size='sm' fullWidth />
      </S.FormStageInputContainer>
      <S.FormStageInputContainer>
        <S.InputLabel>비밀번호 확인</S.InputLabel>
        <S.StageInput type='password' size='sm' fullWidth />
      </S.FormStageInputContainer>
    </>
  );
}

export default RegisterFormState3;

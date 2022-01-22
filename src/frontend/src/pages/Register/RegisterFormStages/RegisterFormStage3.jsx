import React from 'react';

import * as S from './RegisterFormStages.style';

function RegisterFormState3({ values, errors, touched, onChange, onBlur }) {
  const { password, passwordCheck } = values;

  return (
    <>
      <S.FormStageInputContainer>
        <S.InputLabel>비밀번호</S.InputLabel>
        <S.StageInput
          name='password'
          type='password'
          size='sm'
          fullWidth
          value={password}
          onChange={onChange}
          onBlur={onBlur}
        />
        {touched.password && errors.passwords && <div>{errors.passwords}</div>}
      </S.FormStageInputContainer>
      <S.FormStageInputContainer>
        <S.InputLabel>비밀번호 확인</S.InputLabel>
        <S.StageInput
          name='passwordCheck'
          type='password'
          size='sm'
          fullWidth
          value={passwordCheck}
          onChange={onChange}
          onBlur={onBlur}
        />
        {touched.passwordCheck && errors.passwordsCheck && <div>{errors.passwordsCheck}</div>}
      </S.FormStageInputContainer>
    </>
  );
}

export default RegisterFormState3;

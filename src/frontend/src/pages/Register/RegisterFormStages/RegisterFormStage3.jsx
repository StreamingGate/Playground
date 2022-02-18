import React from 'react';

import * as S from './RegisterFormStages.style';

/**
 *
 * @returns 세 번째 회원가입 폼
 */

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
          error={!!(touched.password && errors.password)}
          helperText={errors.password}
        />
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
          error={!!(touched.passwordCheck && errors.passwordCheck)}
          helperText={errors.passwordCheck}
        />
      </S.FormStageInputContainer>
    </>
  );
}

export default RegisterFormState3;

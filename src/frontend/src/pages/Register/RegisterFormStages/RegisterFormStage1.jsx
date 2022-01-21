import React, { useState, memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './RegisterFormStages.style';

import { Button } from '@components/buttons';

function RegisterFormStage1({ values, onChange }) {
  const { name, email, verify } = values;
  const [isVerify, setIsVerify] = useState(false);

  const handleVerifyBtnClick = () => {
    setIsVerify(true);
  };

  return (
    <>
      <S.FormStageInputContainer>
        <S.InputLabel>이름</S.InputLabel>
        <S.StageInput name='name' size='sm' fullWidth value={name} onChange={onChange} />
      </S.FormStageInputContainer>
      <S.FormStageInputContainer>
        <S.InputLabel>이메일</S.InputLabel>
        <S.StageInput name='email' size='sm' fullWidth value={email} onChange={onChange} />
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
          <S.StageInput name='verify' size='sm' fullWidth value={verify} onChange={onChange} />
        </S.FormStageInputContainer>
      )}
    </>
  );
}

RegisterFormStage1.propTypes = {
  values: PropTypes.shape({
    name: PropTypes.string,
    email: PropTypes.string,
    verify: PropTypes.string,
  }).isRequired,
};

export default memo(RegisterFormStage1);

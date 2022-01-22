import React, { useEffect, useState, memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './RegisterFormStages.style';

import { Button } from '@components/buttons';

function RegisterFormStage1({ values, errors, touched, onChange, onBlur }) {
  const { name, email, verify } = values;
  const [isVerify, setIsVerify] = useState(false);
  const [isVerifyBtnDisable, setVerifyBtnDisable] = useState(true);

  useEffect(() => {
    const { name, email } = values;

    if (name && !errors.name && email && !errors.email) {
      setVerifyBtnDisable(false);
    }
  }, [errors]);

  const handleVerifyBtnClick = () => {
    setIsVerify(true);
  };

  return (
    <>
      <S.FormStageInputContainer>
        <S.InputLabel>이름</S.InputLabel>
        <S.StageInput
          name='name'
          size='sm'
          fullWidth
          value={name}
          onChange={onChange}
          onBlur={onBlur}
          error={!!(touched.name && errors.name)}
          helperText={errors.name}
        />
      </S.FormStageInputContainer>
      <S.FormStageInputContainer>
        <S.InputLabel>이메일</S.InputLabel>
        <S.StageInput
          name='email'
          size='sm'
          fullWidth
          value={email}
          onChange={onChange}
          onBlur={onBlur}
          error={!!(touched.email && errors.email)}
          helperText={errors.email}
        />
      </S.FormStageInputContainer>
      {!isVerify ? (
        <S.VerifyButtonContainer>
          <Button color='pgBlue' disabled={isVerifyBtnDisable} onClick={handleVerifyBtnClick}>
            인증하기
          </Button>
        </S.VerifyButtonContainer>
      ) : (
        <S.FormStageInputContainer>
          <S.InputLabel>이메일 인증</S.InputLabel>
          <S.StageInput
            name='verify'
            size='sm'
            fullWidth
            value={verify}
            onChange={onChange}
            onBlur={onBlur}
            error={!!(touched.email && errors.verify)}
            helperText={errors.verify}
          />
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
  errors: PropTypes.object.isRequired,
  touched: PropTypes.object.isRequired,
  onChange: PropTypes.func.isRequired,
  onBlur: PropTypes.func.isRequired,
};

export default memo(RegisterFormStage1);

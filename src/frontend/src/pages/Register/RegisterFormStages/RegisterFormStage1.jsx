import React, { useEffect, useState, memo, useRef } from 'react';
import PropTypes from 'prop-types';

import * as S from './RegisterFormStages.style';

import { Button } from '@components/buttons';

const VERIFY_TIME = 60 * 10;

function parseSecond(seconds) {
  const min = parseInt(seconds / 60, 10);
  const sec = seconds % 60;
  return { min, sec };
}

function RegisterFormStage1({ values, errors, touched, onChange, onBlur }) {
  const { name, email, verify } = values;
  const limitTime = useRef(VERIFY_TIME);
  const timer = useRef(null);

  const [countDown, setCountDown] = useState(parseSecond(limitTime.current));
  const [isVerify, setIsVerify] = useState(false);
  const [isVerifyBtnDisable, setVerifyBtnDisable] = useState(true);

  useEffect(() => {
    return () => {
      clearInterval(timer.current);
    };
  }, []);

  useEffect(() => {
    if (isVerify) {
      limitTime.current = VERIFY_TIME;
      setCountDown(parseSecond(limitTime.current));
      timer.current = setInterval(() => {
        limitTime.current -= 1;
        setCountDown(parseSecond(limitTime.current));
      }, 1000);
    }
  }, [isVerify]);

  useEffect(() => {
    if (limitTime.current === 0) {
      clearInterval(timer.current);
      setIsVerify(false);
    }
  }, [countDown]);

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
          <S.EmailVerifyInputContainer>
            <S.StageInput
              name='verify'
              size='sm'
              fullWidth
              value={verify}
              onChange={onChange}
              onBlur={onBlur}
              error={!!(touched.verify && errors.verify)}
              helperText={errors.verify}
            />
            <S.Timer>{`${String(countDown.min).padStart(2, '0')}:${String(countDown.sec).padStart(
              2,
              '0'
            )}`}</S.Timer>
          </S.EmailVerifyInputContainer>
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

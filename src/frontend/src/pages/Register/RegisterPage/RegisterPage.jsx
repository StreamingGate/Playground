import React, { useEffect, useCallback, useState, useMemo } from 'react';
import * as yup from 'yup';

import * as S from './RegisterPage.style';
import { useForm } from '@utils/hook';

import { Stepper } from '@components/dataDisplays';
import RegisterFormStage1 from '../RegisterFormStages/RegisterFormStage1';
import RegisterFormStage2 from '../RegisterFormStages/RegisterFormStage2';
import RegisterFormStage3 from '../RegisterFormStages/RegisterFormStage3';

const STAGE_STEP = 3;
const initBtnContent = { prev: '취소', next: '다음' };

const stage1InitInput = {
  name: '',
  email: '',
  verify: '',
};

const stage2InitInput = {
  profileImage: '',
  nickName: '',
};

const stage3InitInput = {
  password: '',
  passwordCheck: '',
};

const validSchema = yup.object().shape({
  name: yup.string().required('이름을 입력해 주세요'),
  email: yup
    .string()
    .required('이메일을 입력해 주세요')
    .email('올바른 이메일 형식을 입력해 주세요'),
  verify: yup.string().required('인증번호를 입력해 주세요'),
  nickName: yup
    .string()
    .required('닉네임을 입력해 주세요')
    .max(8, '최대 8글자까지 입력하실 수 있습니다'),
  password: yup
    .string()
    .required('비밀번호를 입력해 주세요')
    .matches(
      /^(?=.*[a-z])(?=.*\d)[A-Za-z\d]{6,16}$/,
      '영문 소문자와 숫자를 포함한 6~16자여야 합니다'
    ),
  passwordCheck: yup.string().oneOf([yup.ref('password'), null], '비밀번호가 일치하지 않습니다'),
});

function RegisterPage() {
  const { values, errors, touched, handleInputChange, handleInputBlur } = useForm({
    initialValues: { ...stage1InitInput, ...stage2InitInput, ...stage3InitInput },
    validSchema,
  });

  // console.log(touched);

  const [btnContent, setBtnContent] = useState({ ...initBtnContent });
  const [curStage, setCurState] = useState(1);
  const [isNextInActive, setNextInActive] = useState(false);

  const stage1Input = useMemo(
    () => ({
      name: values.name,
      email: values.email,
      verify: values.verify,
    }),
    [values]
  );

  useEffect(() => {
    const newBtnContent = { ...initBtnContent };
    if (curStage !== 1) {
      newBtnContent.prev = '이전';
    }
    if (curStage === STAGE_STEP) {
      newBtnContent.next = '가입';
    }
    setBtnContent({ ...newBtnContent });
  }, [curStage]);

  const handleClickPrevBtn = () => {
    if (curStage > 1) {
      setCurState(prev => prev - 1);
    }
  };

  const handleClickNextBtn = () => {
    if (curStage >= 1 && curStage < STAGE_STEP) {
      setCurState(prev => prev + 1);
    }
  };

  const renderStage = useCallback(() => {
    switch (curStage) {
      case 2:
        return <RegisterFormStage2 />;
      case 3:
        return <RegisterFormStage3 onPrev={handleClickPrevBtn} />;
      default:
        return (
          <RegisterFormStage1
            values={stage1Input}
            errors={errors}
            touched={touched}
            onChange={handleInputChange}
            onBlur={handleInputBlur}
          />
        );
    }
  }, [curStage, values, touched]);

  return (
    <S.RegisterPageContainer>
      <S.RegisterFormContainer>
        <S.RegisterForm>
          <S.RegisterTitleContainer>
            <S.FormHorizontalLogo />
            <S.RegisterTitle type='title'>에 오신 걸 환영합니다!</S.RegisterTitle>
          </S.RegisterTitleContainer>
          <Stepper step={STAGE_STEP} activeStep={curStage} />
          <S.StageContainer>{renderStage()}</S.StageContainer>
          <S.FormActionContainer>
            <S.PrevButton variant='outlined' onClick={handleClickPrevBtn}>
              <S.PrevBtnContent type='subtitle'>{btnContent.prev}</S.PrevBtnContent>
            </S.PrevButton>
            <S.NextButton color='pgBlue' disabled={isNextInActive} onClick={handleClickNextBtn}>
              <S.NextBtnContent type='subtitle'>{btnContent.next}</S.NextBtnContent>
            </S.NextButton>
          </S.FormActionContainer>
        </S.RegisterForm>
      </S.RegisterFormContainer>
    </S.RegisterPageContainer>
  );
}

export default RegisterPage;

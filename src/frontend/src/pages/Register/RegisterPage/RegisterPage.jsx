import React, { useEffect, useCallback, useState } from 'react';

import * as S from './RegisterPage.style';
import { validation } from '@utils/constant';
import { useForm } from '@utils/hook';
import { useVerifyCode, useVerifyNickName, useUserRegister } from '@utils/hook/query';

import { Stepper } from '@components/dataDisplays';
import RegisterFormStage1 from '../RegisterFormStages/RegisterFormStage1';
import RegisterFormStage2 from '../RegisterFormStages/RegisterFormStage2';
import RegisterFormStage3 from '../RegisterFormStages/RegisterFormStage3';

const STAGE_STEP = 3;
const initBtnContent = { prev: '취소', next: '다음' };

const initialInput = {
  name: '',
  email: '',
  verify: '',
  nickName: '',
  password: '',
  passwordCheck: '',
};

function RegisterPage() {
  const [profileImage, setProfileImage] = useState('');
  const [btnContent, setBtnContent] = useState({ ...initBtnContent });
  const [curStage, setCurState] = useState(1);

  const handleSubmitResponse = data => {
    // 팝업 창으로 변경
    if (data?.errorCode) {
      alert(data.message);
      return;
    }

    if (curStage >= 1 && curStage < STAGE_STEP) {
      setCurState(prev => prev + 1);
    } else if (curStage >= STAGE_STEP) {
      alert('회원가입 완료');
    }
  };

  const verifyCode = useVerifyCode(handleSubmitResponse);
  const verifyNickName = useVerifyNickName(handleSubmitResponse);
  const userRegister = useUserRegister(handleSubmitResponse);

  const handleFormRequest = values => {
    const { verify, nickName } = values;

    switch (curStage) {
      case 1:
        verifyCode.mutate(verify);
        break;
      case 2:
        verifyNickName.mutate(nickName);
        break;
      case 3:
        userRegister.mutate(values);
        break;
      default:
        break;
    }
  };

  const { values, errors, touched, changeValue, handleInputChange, handleInputBlur, handleSubmit } =
    useForm({
      initialValues: { ...initialInput },
      validSchema: validation.register[curStage - 1],
      onSubmit: handleFormRequest,
    });

  const handleClickPrevBtn = () => {
    if (curStage > 1) {
      if (curStage === 2) {
        changeValue(['verify', '']);
      }
      setCurState(prev => prev - 1);
    }
  };

  const changeProfilImage = dataUrl => {
    setProfileImage(dataUrl);
  };

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

  const renderStage = useCallback(() => {
    switch (curStage) {
      case 2:
        return (
          <RegisterFormStage2
            values={{ ...values, profileImage }}
            errors={errors}
            touched={touched}
            onChange={handleInputChange}
            onProfileChange={changeProfilImage}
            onBlur={handleInputBlur}
          />
        );
      case 3:
        return (
          <RegisterFormStage3
            values={values}
            errors={errors}
            touched={touched}
            onChange={handleInputChange}
            onBlur={handleInputBlur}
          />
        );
      default:
        return (
          <RegisterFormStage1
            values={values}
            errors={errors}
            touched={touched}
            onChange={handleInputChange}
            onBlur={handleInputBlur}
          />
        );
    }
  }, [curStage, values, profileImage, touched, errors]);

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
            <S.NextButton color='pgBlue' onClick={handleSubmit}>
              <S.NextBtnContent type='subtitle'>{btnContent.next}</S.NextBtnContent>
            </S.NextButton>
          </S.FormActionContainer>
        </S.RegisterForm>
      </S.RegisterFormContainer>
    </S.RegisterPageContainer>
  );
}

export default RegisterPage;

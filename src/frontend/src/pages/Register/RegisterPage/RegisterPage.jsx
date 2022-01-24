import React, { useEffect, useCallback, useState } from 'react';
import { useNavigate } from 'react-router-dom';

import * as S from './RegisterPage.style';
import { modalService } from '@utils/service';
import { validation } from '@utils/constant';
import { useForm } from '@utils/hook';
import { useUserRegister } from '@utils/hook/query';

import { Stepper } from '@components/dataDisplays';
import { AdviseModal } from '@components/feedbacks/modals';
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
  const navigate = useNavigate();

  const [profileImage, setProfileImage] = useState('');
  const [btnContent, setBtnContent] = useState({ ...initBtnContent });
  const [curStage, setCurState] = useState(1);

  const handleSubmitResponse = data => {
    if (data?.errorCode) {
      modalService.show(AdviseModal, { content: data.message });
      return;
    }

    if (curStage >= 1 && curStage < STAGE_STEP) {
      setCurState(prev => prev + 1);
    } else if (curStage >= STAGE_STEP) {
      modalService.show(AdviseModal, {
        content: '회원가입이 완료되었습니다',
        btnContent: '로그인 페이지로 이동',
        btnPos: 'center',
        onClick: () => navigate('/login'),
      });
    }
  };

  const verifyCode = useUserRegister('verify-code', handleSubmitResponse);
  const verifyNickName = useUserRegister('verify-nickname', handleSubmitResponse);
  const userRegister = useUserRegister('user-register', handleSubmitResponse);

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
        userRegister.mutate({ ...values, profileImage });
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

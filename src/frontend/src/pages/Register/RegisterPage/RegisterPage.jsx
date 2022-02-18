import React, { useEffect, useCallback, useState } from 'react';
import { useNavigate } from 'react-router-dom';

import * as S from './RegisterPage.style';
import { modalService } from '@utils/service';
import { validation } from '@utils/constant';
import { useForm } from '@utils/hook';
import { useUserRegister } from '@utils/hook/query';

import { Stepper } from '@components/dataDisplays';
import { AdviseModal } from '@components/feedbacks/Modals';
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

/**
 * 세단계의 회원가입 폼 컴포넌트를 단계별로 랜더링하는 페이지
 *
 * @returns {React.Component} 회원가입 페이지
 */
function RegisterPage() {
  const navigate = useNavigate();

  const [profileImage, setProfileImage] = useState('');
  const [btnContent, setBtnContent] = useState({ ...initBtnContent });
  const [curStage, setCurState] = useState(1);

  // 폼에서 요청을 보낸 다음 실행되는 함수
  const handleSubmitResponse = data => {
    if (data?.errorCode) {
      modalService.show(AdviseModal, { content: data.message });
      return;
    }

    // 마지막 단계일 경우 회원가입 완료 모달을 띄우고
    // 나머지 단계일 경우 다음 단계로 이동하는 로직
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

  // 회원가입 단계별 post 요청 함수
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
        userRegister.mutate({ ...values, profileImage: profileImage.split(',')[1] });
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

  // 이전 단계로 이동하는 함수
  const handleClickPrevBtn = () => {
    if (curStage > 1) {
      // 두번째 단계에서 첫번째 단계로 이동할 경우 이메일 인증번호 초기화
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

import React, { useState } from 'react';

import * as S from './RegisterPage.style';

import { Stepper } from '@components/dataDisplays';
import RegisterFormStage1 from '../RegisterFormStages/RegisterFormStage1';

function RegisterPage() {
  const [curStage, setCurState] = useState(1);

  return (
    <S.RegisterPageContainer>
      <S.RegisterFormContainer>
        <S.RegisterForm>
          <S.RegisterTitleContainer>
            <S.FormHorizontalLogo />
            <S.RegisterTitle type='title'>에 오신 걸 환영합니다!</S.RegisterTitle>
          </S.RegisterTitleContainer>
          <Stepper step={3} activeStep={curStage} />
          <div>
            <RegisterFormStage1 />
          </div>
          <S.FormControlBtnContainer>
            <S.PrevButton variant='outlined'>
              <S.PrevBtnCaption type='subtitle'>취소</S.PrevBtnCaption>
            </S.PrevButton>
            <S.NextButton color='pgBlue'>
              <S.NextBtnCaption type='subtitle'>다음</S.NextBtnCaption>
            </S.NextButton>
          </S.FormControlBtnContainer>
        </S.RegisterForm>
      </S.RegisterFormContainer>
    </S.RegisterPageContainer>
  );
}

export default RegisterPage;

import React, { useEffect, useCallback, useState } from 'react';

import * as S from './RegisterPage.style';

import { Stepper } from '@components/dataDisplays';
import RegisterFormStage1 from '../RegisterFormStages/RegisterFormStage1';
import RegisterFormStage2 from '../RegisterFormStages/RegisterFormStage2';
import RegisterFormStage3 from '../RegisterFormStages/RegisterFormStage3';

const STAGE_STEP = 3;
const initBtnContent = { prev: '취소', next: '다음' };

function RegisterPage() {
  const [btnContent, setBtnContent] = useState({ ...initBtnContent });

  const [curStage, setCurState] = useState(1);
  const [isNextInActive, setNextInActive] = useState(false);

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
        return <RegisterFormStage3 />;
      default:
        return <RegisterFormStage1 />;
    }
  }, [curStage]);

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

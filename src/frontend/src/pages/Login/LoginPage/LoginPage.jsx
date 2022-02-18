import React from 'react';

import LoginIntro from '@assets/image/LoginIntro.gif';
import S from './LoginPage.style';

import LoginForm from '../LoginForm/LoginForm';

function LoginPage() {
  return (
    <S.LoginPageContainer>
      <S.OverviewImageContainer>
        <S.LoginIntroGif src={LoginIntro} alt='service overview' />
      </S.OverviewImageContainer>
      <LoginForm />
    </S.LoginPageContainer>
  );
}

export default LoginPage;

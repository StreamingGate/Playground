import React from 'react';

import LoginPageImage from '@assets/image/LoginPageImage.png';

import LoginForm from '../LoginForm/LoginForm';

import S from './LoginPage.style';

function LoginPage() {
  return (
    <S.LoginPageContainer>
      <S.OverviewImageContainer>
        <img src={LoginPageImage} alt='service overview' />
      </S.OverviewImageContainer>
      <LoginForm />
    </S.LoginPageContainer>
  );
}

export default LoginPage;

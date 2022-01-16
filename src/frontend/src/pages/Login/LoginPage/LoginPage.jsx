import React from 'react';

import LoginPageImage from '@assets/image/LoginPageImage.png';
import S from './LoginPage.style';

import LoginForm from '../LoginForm/LoginForm';

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

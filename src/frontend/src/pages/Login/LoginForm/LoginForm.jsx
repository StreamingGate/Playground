import React from 'react';

import { Input } from '@components/forms';
import { Typography } from '@components/cores';
import { Button } from '@components/buttons';

import { placeholder } from '@utils/constant';

import S from './LoginForm.style';

const { loginPage } = placeholder;

function LoginForm() {
  return (
    <S.Form>
      <S.Logo />
      <S.InputContainer>
        <Input fullWidth size='lg' placeholder={loginPage.email} />
        <Input type='password' fullWidth size='lg' placeholder={loginPage.password} />
      </S.InputContainer>
      <Button fullWidth size='lg'>
        <Typography type='subtitle'>로그인</Typography>
      </Button>
      <S.RegisterContainer>
        <Typography type='caption'>계정이 없으신가요?</Typography>
        <Typography type='highlightCaption'>
          <S.RegisterLink to='/'>가입하기</S.RegisterLink>
        </Typography>
      </S.RegisterContainer>
    </S.Form>
  );
}

export default LoginForm;

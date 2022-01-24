import React from 'react';

import { useForm } from '@utils/hook';
import { useLogin } from '@utils/hook/query';

import { Input } from '@components/forms';
import { Typography } from '@components/cores';
import { Button } from '@components/buttons';

import { placeholder, validation } from '@utils/constant';

import S from './LoginForm.style';

const { loginPage } = placeholder;

function LoginForm() {
  const handleLoginResponse = data => {
    // 팝업 창으로 변경
    if (data?.errorCode) {
      alert(data.message);
      return;
    }

    alert('로그인 성공');
  };

  const { mutate } = useLogin(handleLoginResponse);

  const handleLoginRequest = values => {
    mutate(values);
  };

  const { values, errors, touched, handleInputChange, handleInputBlur, handleSubmit } = useForm({
    initialValues: { email: '', password: '' },
    validSchema: validation.login,
    onSubmit: handleLoginRequest,
  });

  return (
    <S.Form>
      <S.Logo />
      <S.InputContainer>
        <Input
          name='email'
          size='lg'
          fullWidth
          placeholder={loginPage.email}
          value={values.email}
          onChange={handleInputChange}
          onBlur={handleInputBlur}
          error={!!(touched.email && errors.email)}
          helperText={errors.email}
        />
        <Input
          name='password'
          type='password'
          size='lg'
          fullWidth
          placeholder={loginPage.password}
          value={values.password}
          onChange={handleInputChange}
          onBlur={handleInputBlur}
          error={!!(touched.password && errors.password)}
          helperText={errors.password}
        />
      </S.InputContainer>
      <Button fullWidth size='lg' onClick={handleSubmit}>
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

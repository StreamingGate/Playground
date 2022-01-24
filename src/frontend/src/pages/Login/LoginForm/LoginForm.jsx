import React from 'react';
import { useNavigate } from 'react-router-dom';

import S from './LoginForm.style';
import { placeholder, validation } from '@utils/constant';
import { modalService, lStorageService } from '@utils/service';
import { useForm } from '@utils/hook';
import { useLogin } from '@utils/hook/query';

import { Input } from '@components/forms';
import { Typography } from '@components/cores';
import { Button } from '@components/buttons';
import { AdviseModal } from '@components/feedbacks/Modals';

const { loginPage } = placeholder;

function LoginForm() {
  const navigate = useNavigate();

  const handleLoginResponse = data => {
    if (data?.errorCode) {
      modalService.show(AdviseModal, { content: data.message });
      return;
    }
    const {
      headers: { token, uuid },
    } = data;
    lStorageService.setItem('token', token);
    lStorageService.setItem('uuid', uuid);
    navigate('/home');
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
          <S.RegisterLink to='/register'>가입하기</S.RegisterLink>
        </Typography>
      </S.RegisterContainer>
    </S.Form>
  );
}

export default LoginForm;

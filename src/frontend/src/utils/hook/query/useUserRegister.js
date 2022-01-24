import { useMutation } from 'react-query';
import axios from 'axios';

const postUserRegister = async values => {
  const { data } = await axios.post(`${process.env.REACT_APP_API}/user-service/users`, {
    ...values,
  });
  return data;
};

const postVerifyEmail = async email => {
  const { data } = await axios.post(`${process.env.REACT_APP_API}/user-service/email`, { email });
  return data;
};

const getVerifyCode = async code => {
  const { data } = await axios.get(`${process.env.REACT_APP_API}/user-service/email?code=${code}`);
  return data;
};

const getVerifyNickName = async nickName => {
  const { data } = await axios.get(
    `${process.env.REACT_APP_API}/user-service/nickname?nickname=${nickName}`
  );
  return data;
};

export default function useUserRegister(type, onSuccess) {
  let requestFn = null;
  switch (type) {
    case 'verify-code':
      requestFn = getVerifyCode;
      break;
    case 'verify-nickname':
      requestFn = getVerifyNickName;
      break;
    case 'verify-email':
      requestFn = postVerifyEmail;
      break;
    default:
      requestFn = postUserRegister;
  }

  return useMutation(arg => requestFn(arg), {
    enabled: false,
    onSuccess,
  });
}

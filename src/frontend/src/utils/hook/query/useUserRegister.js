import { useMutation } from 'react-query';
import axios from 'axios';

const postUserRegister = async values => {
  const { data } = await axios.post(`${process.env.REACT_APP_API}/user-service/users`, {
    ...values,
  });
  return data;
};

const postVerifyCode = async code => {
  const { data } = await axios.get(`${process.env.REACT_APP_API}/user-service/email?code=${code}`);
  return data;
};

const postVerifyNickName = async nickName => {
  const { data } = await axios.get(
    `${process.env.REACT_APP_API}/user-service/nickname?nickname=${nickName}`
  );
  return data;
};

export default function useUserRegister(type, onSuccess) {
  let requestFn = null;
  switch (type) {
    case 'verify-code':
      requestFn = postVerifyCode;
      break;
    case 'verify-nickname':
      requestFn = postVerifyNickName;
      break;
    default:
      requestFn = postUserRegister;
  }

  return useMutation(arg => requestFn(arg), {
    enabled: false,
    onSuccess,
  });
}

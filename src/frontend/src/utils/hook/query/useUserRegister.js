import { useMutation } from 'react-query';
import axios from 'axios';

// /users
const postUserRegister = async values => {
  console.log(values);
  const { data } = await axios.post(`${process.env.REACT_APP_API}/users`, { values });
  return data;
};

// /users/mail?code=#
const postVerifyCode = async code => {
  console.log(code);
  const { data } = await axios.post(`${process.env.REACT_APP_API}/posts`);
  return data;
};

// /nickname?nickname={nickname}
const postVerifyNickName = async nickName => {
  console.log(nickName);
  const { data } = await axios.post(`${process.env.REACT_APP_API}/posts`);
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

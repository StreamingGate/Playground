import { useMutation } from 'react-query';
import axios from 'axios';

// /users
const postUserRegister = async values => {
  const { data } = await axios.post(`${process.env.REACT_APP_API}/users`, { values });
  return data;
};

// /users/mail?code=#
const postVerifyCode = async code => {
  const { data } = await axios.get(`${process.env.REACT_APP_API}/users/mail?code=${code}`);
  return data;
};

// /nickname?nickname={nickname}
const postVerifyNickName = async nickName => {
  const { data } = await axios.get(`${process.env.REACT_APP_API}/nickname?nickname=${nickName}`);
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

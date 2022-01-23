import { useMutation } from 'react-query';
import axios from 'axios';

// /users/mail?code=#
const postVerifyCode = async code => {
  console.log(code);
  const { data } = await axios.post(`${process.env.REACT_APP_API}/posts`);
  return data;
};

export default function useVerifyCode(onSuccess) {
  return useMutation(code => postVerifyCode(code), {
    enabled: false,
    onSuccess,
  });
}

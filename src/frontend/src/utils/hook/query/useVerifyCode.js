import { useQuery } from 'react-query';
import axios from 'axios';

// /users/mail?code=#
const postVerifyCode = async code => {
  const { data } = await axios.post(`${process.env.REACT_APP_API}/posts`);
  return data;
};

export default function useVerifyCode(code, onSuccess) {
  return useQuery('verify-code', () => postVerifyCode(code), {
    enabled: false,
    onSuccess,
  });
}

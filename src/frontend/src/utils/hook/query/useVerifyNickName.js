import { useQuery } from 'react-query';
import axios from 'axios';

// /nickname?nickname={nickname}
const postVerifyNickName = async nickName => {
  const { data } = await axios.post(`${process.env.REACT_APP_API}/posts`);
  return data;
};

export default function useVerifyNickName(nickName, onSuccess) {
  return useQuery('verify-nickname', () => postVerifyNickName(nickName), {
    enabled: false,
    onSuccess,
  });
}

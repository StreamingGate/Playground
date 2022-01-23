import { useMutation } from 'react-query';
import axios from 'axios';

// /nickname?nickname={nickname}
const postVerifyNickName = async nickName => {
  console.log(nickName);
  const { data } = await axios.post(`${process.env.REACT_APP_API}/posts`);
  return data;
};

export default function useVerifyNickName(onSuccess) {
  return useMutation(nickName => postVerifyNickName(nickName), {
    enabled: false,
    onSuccess,
  });
}

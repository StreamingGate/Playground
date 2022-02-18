import { useMutation } from 'react-query';
import axios from 'axios';
// import axios from 'axios';

const postUserLogin = async values => {
  const data = await axios.post(`${process.env.REACT_APP_API}/user-service/login`, {
    ...values,
  });
  // const data = await axios.post(`https://dev.streaminggate.shop/user-service/login`, { ...values });
  return data;
};

export default function useLogin(onSuccess) {
  return useMutation(values => postUserLogin(values), { onSuccess });
}

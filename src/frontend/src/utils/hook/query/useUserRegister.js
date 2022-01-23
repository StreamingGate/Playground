import { useMutation } from 'react-query';
import axios from 'axios';

// /users
const postUserRegister = async values => {
  console.log(values);
  const { data } = await axios.post(`${process.env.REACT_APP_API}/users`, { values });
};

export default function useUserRegister(onSuccess) {
  return useMutation(values => postUserRegister(values), {
    enabled: false,
    onSuccess,
  });
}

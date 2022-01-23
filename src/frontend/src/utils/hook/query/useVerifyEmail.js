import { useQuery } from 'react-query';
import axios from 'axios';

// /users/mail?email=#
const postVerifyEmail = async email => {
  const { data } = await axios.post(`${process.env.REACT_APP_API}/posts`);
  return data;
};

export default function useVerifyEmaii(emailAddress, onSuccess) {
  return useQuery(['verify-email', emailAddress], () => postVerifyEmail(emailAddress), {
    enabled: false,
    onSuccess,
  });
}

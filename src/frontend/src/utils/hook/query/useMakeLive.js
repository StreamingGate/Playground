import { useMutation } from 'react-query';
import axios from '@utils/axios';

const postMakeLive = async body => {
  const data = await axios.post('/room-service/room', body);
  return data;
};

export default function useMakeLive(handleMakeLiveSuccess) {
  return useMutation(body => postMakeLive(body), {
    onSuccess: handleMakeLiveSuccess,
  });
}

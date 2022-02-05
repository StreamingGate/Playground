import { useMutation } from 'react-query';
import axios from '@utils/axios';

const postUploadVideo = async formData => {
  const { data } = await axios.post(`/upload-service/upload`, formData, {
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
  });
  return data;
};

export default function useUploadVideo() {
  return useMutation(formData => postUploadVideo(formData));
}

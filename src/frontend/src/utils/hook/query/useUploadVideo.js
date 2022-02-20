import { useMutation } from 'react-query';
import axios from '@utils/axios';

import { toast } from 'react-toastify';

const postUploadVideo = async formData => {
  const { data } = await axios.post(
    `${process.env.REACT_APP_API}/upload-service/upload`,
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }
  );
  return data;
};

const option = {
  autoClose: false,
  position: 'top-right',
};

export default function useUploadVideo() {
  return useMutation(formData => postUploadVideo(formData), {
    onMutate: () => {
      toast.dismiss();
      toast.info('비디오 업로드 중 입니다...', option);
    },
    onSuccess: () => {
      toast.dismiss();
      toast.success('업로드를 완료했습니다.', { ...option, autoClose: 5000 });
    },
    onError: () => {
      toast.dismiss();
      toast.warn('업로드에 실패했습니다.', { ...option, autoClose: 5000 });
    },
  });
}

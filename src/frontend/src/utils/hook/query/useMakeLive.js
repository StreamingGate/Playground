import { useMutation } from 'react-query';
import axios from '@utils/axios';

import { toast } from 'react-toastify';

const postMakeLive = async body => {
  const data = await axios.post('/room-service/room', body);
  return data;
};

const option = {
  autoClose: false,
  position: 'top-right',
};

export default function useMakeLive(handleMakeLiveSuccess) {
  return useMutation(body => postMakeLive(body), {
    onMutate: () => {
      toast.dismiss();
      toast.info('실시간 스트리밍 시작 중...', option);
    },
    onSuccess: async data => {
      toast.dismiss();
      await handleMakeLiveSuccess(data);
    },
    onError: () => {
      toast.dismiss();
      toast.warn('실시간 스트리밍 생성에 실패했습니다. 다시 시도해 주세요', {
        ...option,
        autoClose: 5000,
      });
    },
  });
}

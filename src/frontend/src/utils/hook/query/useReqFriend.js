import { useMutation } from 'react-query';
import axios from '@utils/axios';

import { lStorageService } from '@utils/service';

const reqFriend = async target => {
  const userId = lStorageService.getItem('uuid');
  const data = await axios.post(`/main-service/friends/${userId}`, { target });
  return data;
};

export default function useReqFriend(onSuccess) {
  return useMutation(target => reqFriend(target), {
    onSuccess,
  });
}

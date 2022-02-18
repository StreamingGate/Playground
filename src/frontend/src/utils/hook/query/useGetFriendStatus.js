import { useQuery } from 'react-query';
import axios from '@utils/axios';

const getFriendStatusList = async uuid => {
  const data = await axios.get(`${process.env.REACT_APP_USER_STATUS_API}/list?uuid=${uuid}`);
  return data.result;
};

export default function useGetFriendStatus(uuid, onSuccess) {
  return useQuery('friends-status', () => getFriendStatusList(uuid), {
    refetchOnWindowFocus: false,
    onSuccess,
  });
}

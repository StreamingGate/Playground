import { useQuery } from 'react-query';
import axios from '@utils/axios';

const getFriendReqList = async uuid => {
  const data = await axios.get(`/main-service/friends/manage/${uuid}`);
  return data;
};

export default function useGetFriendReqList(uuid) {
  return useQuery('friends_req', () => getFriendReqList(uuid), {
    refetchOnWindowFocus: false,
  });
}

import { useQuery } from 'react-query';
import axios from '@utils/axios';

const getFriendList = async uuid => {
  const data = await axios.get(`/main-service/friends/${uuid}`);
  return data;
};

export default function useFriendList(uuid) {
  return useQuery('friends', () => getFriendList(uuid));
}

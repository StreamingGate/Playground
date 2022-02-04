import { useQuery } from 'react-query';
import axios from '@utils/axios';

const getNotiList = async uuid => {
  const data = await axios.get(`/main-service/notification/${uuid}`);
  return data;
};

export default function useGetNotiList(uuid) {
  return useQuery('notifications', () => getNotiList(uuid), { refetchOnWindowFocus: false });
}

import { useQuery } from 'react-query';
import axios from '@utils/axios';

const getChannelInfo = async uuid => {
  const data = await axios.get(`/user-service/${uuid}`);
  return data;
};

export default function useGetChannelInfo(uuid) {
  return useQuery('channel_info', () => getChannelInfo(uuid), {
    refetchOnWindowFocus: false,
  });
}

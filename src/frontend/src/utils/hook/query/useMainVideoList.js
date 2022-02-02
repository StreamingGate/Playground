import { useInfiniteQuery } from 'react-query';
import axios from '@utils/axios';

const getMainVideoList = async ({ pageParam = 0 }) => {
  const data = await axios.get(`/main-service/list?page=${pageParam}&size=3&category=ALL`);
  return data;
};

export default function useMainVideoList() {
  return useInfiniteQuery('main', getMainVideoList, {
    getNextPageParam: (lastPage, pages) => {
      if (lastPage.liveRooms.length === 0 && lastPage.videos.length === 0) {
        return undefined;
      }
      return pages.length;
    },
  });
}

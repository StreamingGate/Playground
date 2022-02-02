import { useInfiniteQuery } from 'react-query';
import axios from '@utils/axios';

const getMainVideoList = async ({ pageParam = 0 }) => {
  const data = await axios.get(`/main-service/list?page=${pageParam}&size=3&category=ALL`);
  return data;
};

export default function useMainVideoList() {
  return useInfiniteQuery('main', getMainVideoList, {
    refetchOnWindowFocus: false,
    getNextPageParam: (lastPage, pages) => {
      // console.log('~~~~~~~~~~~~~~~~~~~~~~~');
      // console.log(lastPage.liveRooms.length);
      // console.log(lastPage.videos.length);
      // console.log('~~~~~~~~~~~~~~~~~~~~~~~');

      if (lastPage.liveRooms.length === 0 && lastPage.videos.length === 0) {
        return undefined;
      }
      return pages.length;
    },
  });
}

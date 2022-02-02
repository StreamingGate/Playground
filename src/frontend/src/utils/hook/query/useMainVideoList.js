import { useInfiniteQuery } from 'react-query';
import axios from '@utils/axios';

const getMainVideoList = async ({ pageParam = 0 }) => {
  const data = await axios.get(`/main-service/list?page=${pageParam}&size=5&category=ALL`);
  return data;
};

export default function useMainVideoList() {
  return useInfiniteQuery('main', getMainVideoList, {
    getNextPageParam: (lastPage, pages) => {
      // console.log('~~~~~lastpage~~~~~');
      // console.log(lastPage);
      // console.log('~~~~~~~~~~~~~~~~~~');
      // console.log('~~~~~~~pages~~~~~~');
      // console.log(pages);
      // console.log('~~~~~~~~~~~~~~~~~~');
      return lastPage.nextCursor;
    },
  });
}

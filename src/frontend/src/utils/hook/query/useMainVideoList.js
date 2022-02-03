import { useInfiniteQuery } from 'react-query';
import axios from '@utils/axios';

const getMainVideoList = async ({ pageParam = { lastVideo: -1, lastLive: -1 }, queryKey }) => {
  const { lastVideo, lastLive } = pageParam;
  const data = await axios.get(
    `/main-service/list?last-video=${lastVideo}&last-live=${lastLive}&size=3&category=${queryKey[1]}`
  );
  return data;
};

export default function useMainVideoList(category) {
  return useInfiniteQuery(['main', category], getMainVideoList, {
    refetchOnWindowFocus: false,
    getNextPageParam: lastPage => {
      const { liveRooms, videos } = lastPage;

      if (liveRooms.length === 0 && videos.length === 0) {
        return undefined;
      }

      return {
        lastVideo: videos[videos.length - 1]?.id,
        lastLive: liveRooms[liveRooms.length - 1]?.id,
      };
    },
  });
}

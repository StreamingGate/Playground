import { useRef } from 'react';
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
  const lastVideo = useRef(-1);
  const lastLive = useRef(-1);

  return useInfiniteQuery(['main', category], getMainVideoList, {
    refetchOnWindowFocus: false,
    getNextPageParam: lastPage => {
      const { liveRooms, videos } = lastPage;

      if (liveRooms.length === 0 && videos.length === 0) {
        return undefined;
      }

      if (videos[videos.length - 1]?.id) {
        lastVideo.current = videos[videos.length - 1].id;
      }

      if (liveRooms[liveRooms.length - 1]?.id) {
        lastLive.current = liveRooms[liveRooms.length - 1].id;
      }

      return {
        lastVideo: lastVideo.current,
        lastLive: lastLive.current,
      };
    },
  });
}

import { useRef } from 'react';
import { useInfiniteQuery } from 'react-query';
import axios from '@utils/axios';

const getMyList = async ({ pageParam = { lastVideo: -1, lastLive: -1 }, queryKey }) => {
  const { lastVideo, lastLive } = pageParam;
  const [_, type, userId] = queryKey;
  let size = 5;
  if (lastVideo === -1 && lastLive === -1) {
    size = 15;
  }

  const data = await axios.get(
    `/user-service/${type}/${userId}/?last-video=${lastVideo}&last-live=${lastLive}&size=${size}`
  );

  return data;
};

const getMyUploadList = async ({ pageParam = -1, queryKey }) => {
  const [_, type, userId] = queryKey;
  let size = 5;
  if (pageParam === -1) {
    size = 15;
  }
  const data = await axios.get(
    `/user-service/${type}/${userId}/?last-video=${pageParam}&size=${size}`
  );
  return data;
};

export default function useGetMyList(type, uuid) {
  const lastVideo = useRef(-1);
  const lastLive = useRef(-1);

  const getMyListNextPage = lastPage => {
    const { rooms, videos } = lastPage;

    if (rooms.length === 0 && videos.length === 0) {
      return undefined;
    }

    if (videos[videos.length - 1]?.id) {
      lastVideo.current = videos[videos.length - 1].id;
    }

    if (rooms[rooms.length - 1]?.id) {
      lastLive.current = rooms[rooms.length - 1].id;
    }

    return {
      lastVideo: lastVideo.current,
      lastLive: lastLive.current,
    };
  };

  const getMyUploadListNextPage = lastPage => {
    if (lastPage.length === 0) {
      return undefined;
    }

    if (lastPage[lastPage.length - 1]?.id) {
      lastVideo.current = lastPage[lastPage.length - 1].id;
    }

    return lastVideo.current;
  };

  return useInfiniteQuery(['my', type, uuid], type === 'upload' ? getMyUploadList : getMyList, {
    refetchOnWindowFocus: false,
    getNextPageParam: type === 'upload' ? getMyUploadListNextPage : getMyListNextPage,
  });
}

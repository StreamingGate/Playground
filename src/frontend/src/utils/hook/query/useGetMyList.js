import { useRef } from 'react';
import { useInfiniteQuery } from 'react-query';
import axios from '@utils/axios';

const getMyList = async ({ pageParam = { lastVideo: 'null', lastLive: 'null' }, queryKey }) => {
  const { lastVideo, lastLive } = pageParam;
  const [_, type, userId] = queryKey;
  let size = 5;
  if (lastVideo === 'null' && lastLive === 'null') {
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
  const lastVideo = useRef('null');
  const lastLive = useRef('null');

  const getMyListNextPage = lastPage => {
    const { rooms, videos } = lastPage;

    if (rooms.length === 0 && videos.length === 0) {
      return undefined;
    }

    if (type === 'liked') {
      if (videos[videos.length - 1]?.likedAt) {
        lastVideo.current = videos[videos.length - 1].likedAt;
      }

      if (rooms[rooms.length - 1]?.likedAt) {
        lastLive.current = rooms[rooms.length - 1].likedAt;
      }
    } else if (type === 'watch') {
      if (videos[videos.length - 1]?.lastViewedAt) {
        lastVideo.current = videos[videos.length - 1].lastViewedAt;
      }

      if (rooms[rooms.length - 1]?.lastViewedAt) {
        lastLive.current = rooms[rooms.length - 1].lastViewedAt;
      }
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
    refetchOnMount: true,
    getNextPageParam: type === 'upload' ? getMyUploadListNextPage : getMyListNextPage,
  });
}

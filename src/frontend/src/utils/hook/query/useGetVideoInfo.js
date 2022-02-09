import { useQuery } from 'react-query';
import axios from '@utils/axios';

const getVideoInfo = async (videoId, uuid) => {
  const data = await axios.get(`/video-service/video/${videoId}/?uuid=${uuid}`);
  return data;
};

const getLiveInfo = async (roomId, uuid) => {
  const data = await axios.get(`/room-service/room?roomId=${roomId}&uuid=${uuid}`);
  return data;
};

export default function useGetVideoInfo(type, videoId, uuid, onSuccess) {
  return useQuery(
    [type, videoId],
    () => {
      let reqMethod = null;
      switch (type) {
        case 'live':
          reqMethod = getLiveInfo;
          break;
        default:
          reqMethod = getVideoInfo;
          break;
      }

      return reqMethod(videoId, uuid);
    },
    { onSuccess, refetchOnWindowFocus: false }
  );
}

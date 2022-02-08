import { useQuery } from 'react-query';
import axios from '@utils/axios';

const getVideoInfo = async (videoId, uuid) => {
  const data = await axios.get(`/video-service/video/${videoId}/?uuid=${uuid}`);
  return data;
};

export default function useGetVideoInfo(type, videoId, uuid) {
  return useQuery([type, videoId], () => {
    let reqMethod = null;
    switch (type) {
      default:
        reqMethod = getVideoInfo;
        break;
    }

    return reqMethod(videoId, uuid);
  });
}

import { useQuery } from 'react-query';
import axios from '@utils/axios';

const getChatInfo = async roomId => {
  if (!roomId) {
    return null;
  }
  const data = await axios.get(`${process.env.REACT_APP_CHAT_API}/chat/room/${roomId}`);
  return data;
};

export default function useGetChatRoomInfo(roomId, onSuccess) {
  return useQuery('chat_info', () => getChatInfo(roomId), {
    refetchOnWindowFocus: false,
    onSuccess,
  });
}

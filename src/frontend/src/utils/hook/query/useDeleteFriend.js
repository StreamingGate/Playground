import { useMutation, useQueryClient } from 'react-query';
import axios from '@utils/axios';

const deleteFriend = async (target, myId) => {
  const data = await axios.delete(`/main-service/friends/${myId}`, { data: { target } });
  return data;
};

export default function useFriendDelete() {
  const queryClient = useQueryClient();
  return useMutation(({ target, myId }) => deleteFriend(target, myId), {
    onSuccess: () => {
      queryClient.invalidateQueries(['friends']);
    },
  });
}

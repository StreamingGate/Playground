import { useMutation, useQueryClient } from 'react-query';
import axios from '@utils/axios';

const acceptFriend = async (target, myId) => {
  const data = await axios.post(`/main-service/friends/manage/${myId}`, { sender: target });
  return data;
};

const declineFriend = async (target, myId) => {
  const data = await axios.delete(`/main-service/friends/manage/${myId}`, {
    data: { sender: target },
  });
  return data;
};

export default function useHandleFriendReq() {
  const queryClient = useQueryClient();

  return useMutation(
    ({ type, target, myId }) => {
      let reqMethod = null;
      switch (type) {
        case 'accept':
          reqMethod = acceptFriend;
          break;
        default:
          reqMethod = declineFriend;
          break;
      }
      reqMethod(target, myId);
    },
    {
      onSuccess: () => {
        queryClient.invalidateQueries(['friends_req']);
        queryClient.invalidateQueries(['friends']);
      },
    }
  );
}

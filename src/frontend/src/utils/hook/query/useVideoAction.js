import { useMutation } from 'react-query';
import axios from '@utils/axios';

const postAction = async actionBody => {
  const data = await axios.post('/main-service/action', actionBody);
  return { data, action: actionBody.action };
};

const cancelAction = async actionBody => {
  const data = await axios.delete('/main-service/action', { data: actionBody });
  return { data, action: actionBody.action };
};

export default function useVideoAction(handleReqSucess) {
  return useMutation(
    ({ type, actionBody }) => {
      let reqMethod = null;
      switch (type) {
        case 'post':
          reqMethod = postAction;
          break;
        default:
          reqMethod = cancelAction;
          break;
      }

      return reqMethod(actionBody);
    },
    {
      onSuccess: data => {
        const { action } = data;
        handleReqSucess(action);
      },
    }
  );
}

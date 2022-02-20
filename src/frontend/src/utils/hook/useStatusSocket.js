import { useState, useRef, useEffect } from 'react';
import SockJS from 'sockjs-client';
import { Client } from '@stomp/stompjs';

import { useGetFriendStatus } from '@utils/hook/query';
import { lStorageService } from '@utils/service';

export default function useStatusSocket() {
  const temp = useRef(null);
  const [stompClient, setStompClient] = useState(null);
  const [friendStatus, setFriendStatus] = useState([]);
  const [newStatus, setNewStatus] = useState(null);
  const [crudStatus, setCrudStatus] = useState(null);

  const userId = lStorageService.getItem('uuid');
  const token = lStorageService.getItem('token');

  // 클로저로 인해 friendStatus의 초기값을 기억하고 있어 useEffect로 업데이트 처리
  // 친구 유저 상태 변화
  useEffect(() => {
    if (newStatus) {
      const newFriendStatus = [...friendStatus];
      const findIdx = newFriendStatus.findIndex(({ uuid }) => uuid === newStatus.uuid);

      if (findIdx === -1) {
        setFriendStatus([...newFriendStatus, newStatus]);
      } else {
        setFriendStatus([
          ...newFriendStatus.slice(0, findIdx),
          newStatus,
          ...newFriendStatus.slice(findIdx + 1, newFriendStatus.length),
        ]);
      }
    }
  }, [newStatus]);

  useEffect(() => {
    if (crudStatus) {
      const { addOrDelete } = crudStatus;
      if (!addOrDelete) {
        const newFriendStatus = [...friendStatus];
        const findIdx = newFriendStatus.findIndex(({ uuid }) => uuid === crudStatus.uuid);

        setFriendStatus([
          ...newFriendStatus.slice(0, findIdx),
          ...newFriendStatus.slice(findIdx + 1, newFriendStatus.length),
        ]);
      } else if (addOrDelete) {
        setFriendStatus(prev => [...prev, crudStatus]);
      }
    }
  }, [crudStatus]);

  const recvUpdateStatusMessage = message => {
    const { body } = message;

    const parsedMessage = JSON.parse(body);

    setNewStatus(parsedMessage);
  };

  const recvUpdateFriendMessage = message => {
    const { body } = message;

    const parsedMessage = JSON.parse(body);

    setCrudStatus(parsedMessage);
  };

  const { data } = useGetFriendStatus(userId, () => {});

  useEffect(() => {
    if (data && !stompClient) {
      const newClient = new Client();

      newClient.connectHeaders = { token };
      newClient.disconnectHeaders = { uuid: userId };
      newClient.webSocketFactory = () => {
        return new SockJS(process.env.REACT_APP_USER_STATUS_SOCKET);
      };

      setFriendStatus(data);

      newClient.onConnect = () => {
        temp.current = newClient;
        newClient.subscribe(`/topic/friends/${userId}`, recvUpdateStatusMessage);
        newClient.subscribe(`/topic/friends/update/${userId}`, recvUpdateFriendMessage);

        setStompClient(newClient);
      };

      newClient.activate();
    }
  }, [data]);

  return { friendStatus, stompClient };
}

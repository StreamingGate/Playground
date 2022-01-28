import { useEffect, useState } from 'react';
import SockJS from 'sockjs-client';
import { Client } from '@stomp/stompjs';

export default function useSocket(roomId) {
  const [stompClient, setStompClient] = useState(null);
  const [chatData, setChatData] = useState([]);

  const recvChatMessage = message => {
    const { body } = message;

    setChatData(prev => [...prev, JSON.parse(body)]);
  };

  useEffect(() => {
    const newClient = new Client();

    newClient.webSocketFactory = () => {
      return new SockJS(process.env.REACT_APP_CHAT_SOCKET);
    };

    newClient.onConnect = () => {
      newClient.subscribe(`/topic/chat/room/${roomId}`, recvChatMessage);
    };

    setStompClient(newClient);

    newClient.activate();

    return () => {
      newClient.deactivate();
    };
  }, []);

  const sendChatMessage = message => {
    stompClient.publish({
      destination: `/app/chat/message/${roomId}`,
      body: JSON.stringify({
        roomId,
        nickname: '이것은 아이디다',
        senderRole: 'VIEWER',
        chatType: 'NORMAL',
        message,
      }),
    });
  };

  return { chatData, sendChatMessage };
}

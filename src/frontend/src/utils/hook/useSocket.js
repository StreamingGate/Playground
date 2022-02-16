import { useEffect, useState } from 'react';
import SockJS from 'sockjs-client';
import { Client } from '@stomp/stompjs';

import { useGetChatRoomInfo } from '@utils/hook/query';
import { lStorageService } from '@utils/service';

/**
 * 채팅방 소켓 연결 처리 커스텀 훅
 *
 * @param {string} roomId 채팅 방 id
 * @returns {Object}
 * chatData: 주고 받은 채팅 기록
 * sendChatMessage: 채팅 전송 함수
 */

export default function useSocket(roomId, senderRole) {
  const [stompClient, setStompClient] = useState(null);
  const [pinnedChat, setPinnedChat] = useState(null);
  const [chatData, setChatData] = useState([]);
  const [curUserCount, setCurUserCount] = useState(0);

  const userId = lStorageService.getItem('uuid');
  const token = lStorageService.getItem('token');
  const nickName = lStorageService.getItem('nickName');

  const recvChatMessage = message => {
    const { body } = message;

    const parsedMessage = JSON.parse(body);
    const { chatType } = parsedMessage;

    if (chatType === 'PINNED') {
      setPinnedChat(parsedMessage);
    }
    setChatData(prev => [...prev, parsedMessage]);
  };

  const recvChatRoomInfo = message => {
    const { body } = message;

    const { userCnt } = JSON.parse(body);
    setCurUserCount(userCnt);
  };

  const handleGetChatInfoSuccess = data => {
    const { pinnedChat: newPinnedChat } = data;
    if (newPinnedChat) {
      setPinnedChat(newPinnedChat);
    }
  };

  const { data } = useGetChatRoomInfo(roomId, handleGetChatInfoSuccess);

  useEffect(() => {
    const newClient = new Client();

    newClient.connectHeaders = { token };
    newClient.disconnectHeaders = { uuid: userId, roomUuid: roomId, senderRole };
    newClient.webSocketFactory = () => {
      return new SockJS(process.env.REACT_APP_CHAT_SOCKET);
    };

    newClient.onConnect = () => {
      newClient.subscribe(`/topic/chat/room/${roomId}`, recvChatMessage);
      newClient.subscribe(`/topic/chat/enter/${roomId}`, recvChatRoomInfo, { uuid: userId });
    };

    setStompClient(newClient);

    newClient.activate();

    window.addEventListener('beforeunload', () => {
      newClient.deactivate();
    });

    // 소켓 연결 페이지에서 벗어날시 소켓 연결 해제
    return () => {
      newClient.deactivate();
    };
  }, []);

  const sendChatMessage = message => {
    stompClient.publish({
      destination: `/app/chat/message/${roomId}`,
      body: JSON.stringify({
        roomUuid: roomId,
        uuid: userId,
        nickname: nickName,
        senderRole,
        chatType: 'NORMAL',
        message,
      }),
    });
  };

  return { chatData, curUserCount, pinnedChat, sendChatMessage };
}

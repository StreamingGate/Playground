package com.example.statusservice.redis;

import com.example.chatservice.dto.chat.Chat;
import com.example.chatservice.utils.ClientMessaging;
import com.example.chatservice.utils.RedisMessaging;
import com.example.statusservice.utils.ClientMessaging;
import com.example.statusservice.utils.RedisMessaging;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**<h1>RedisSubscriber</h1>
* Redis에 메세지 발행이 되길 기다렸다가 발행되면 해당 메시지를 읽어 처리한다.
*
*/
@Slf4j
@RequiredArgsConstructor
@Service
public class RedisSubscriber implements MessageListener {

   private final ObjectMapper objectMapper;

   /**
    * Redis에서 메시지가 발행(publish)되면 대기하고 있던 onMessage가 해당 메시지를 받아 처리한다.
    */
   @Override
   public void onMessage(Message message, byte[] pattern) {
       try {
           // redis에서 발행된 데이터를 받아 deserialize
           String publishMessage = RedisMessaging.getPublishedMessage(message);
           // ChatMessage 객채로 맵핑
           Chat chat = objectMapper.readValue(publishMessage, Chat.class);
           // Websocket 구독자에게 채팅 메시지 Send
           ClientMessaging.publish("/topic/chat/room/" + chat.getRoomId(), chat);
       } catch (Exception e) {
           log.error(e.getMessage());
       }
   }
}
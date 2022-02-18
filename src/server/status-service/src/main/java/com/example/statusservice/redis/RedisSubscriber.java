package com.example.statusservice.redis;


import com.example.statusservice.dto.UserDto;
import com.example.statusservice.utils.ClientMessaging;
import com.example.statusservice.utils.RedisMessaging;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * <h1>RedisSubscriber</h1>
 * Redis에 메세지 발행이 되길 기다렸다가 발행되면 해당 메시지를 읽어 처리한다.
*/
@Slf4j
@RequiredArgsConstructor
@Service
public class RedisSubscriber implements MessageListener {

   private final ObjectMapper objectMapper;

   /* Redis에서 메시지가 발행(publish)되면 대기하고 있던 onMessage가 해당 메시지를 처리 */
   @Override
   public void onMessage(Message message, byte[] pattern) {
      try {
         log.info("==onMessage==");
         String publishMessage = RedisMessaging.getPublishedMessage(message);
         UserDto userDto = objectMapper.readValue(publishMessage, UserDto.class);
         log.info("==Publish from: " + userDto.getUuid());

         if(userDto.getAddOrDelete() == null) {
            /* 친구 리스트에게 publish */
            for (String friendUuid : userDto.getFriendUuids()) {
               log.info("==Publish to: " + friendUuid);
               /* Websocket 구독자에게 채팅 메시지 Send */
               ClientMessaging.publish("/topic/friends/" + friendUuid, userDto);
            }
         } else{
            log.info("==Publish to: " + userDto.getUpdateTargetUuid());
            ClientMessaging.publish("/topic/friends/update/" + userDto.getUpdateTargetUuid(), userDto);
         }
      } catch (Exception e) {
         log.error(e.getMessage());
      }
   }
}
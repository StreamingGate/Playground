package com.example.chatservice.redis;

import com.example.chatservice.exception.ErrorResponse;
import com.example.chatservice.model.chat.Chat;
import com.example.chatservice.utils.RedisMessaging;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.stereotype.Service;

@Slf4j
@RequiredArgsConstructor
@Service
public class RedisPublisher {

   public void publish(ChannelTopic topic, Chat chat) {
       log.info("topic:" + topic.getTopic());
       RedisMessaging.publishTo(topic, chat);
   }

   /**
    * error handling
    */
   public void publish(ChannelTopic topic, ErrorResponse errorResponse) {
        log.info("topic:" + topic.getTopic());
       RedisMessaging.publishTo(topic, errorResponse);
   }
}
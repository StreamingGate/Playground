package com.example.chatservice.redis;

import com.example.chatservice.model.chat.Chat;

import com.example.exception.ErrorResponse;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class RedisPublisher {

   private final RedisTemplate<String, Object> redisTemplate;

   public void publish(ChannelTopic topic, Chat chat) {
       log.info("topic:" + topic.getTopic());
       redisTemplate.convertAndSend(topic.getTopic(), chat);
   }

   /**
    * error handling
    */
   public void publish(ChannelTopic topic, ErrorResponse errorResponse) {
    log.info("topic:" + topic.getTopic());
    redisTemplate.convertAndSend(topic.getTopic(), errorResponse);
   }
}
package com.example.chatservice.redis;

import com.example.chatservice.dto.ChatDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.stereotype.Service;

@Slf4j
@RequiredArgsConstructor
@Service
public class RedisPublisher {
   private final RedisTemplate<String, Object> redisTemplate;

   public void publish(ChannelTopic topic, ChatDto chatDto) {
       log.info("topic:" + topic.getTopic());
       redisTemplate.convertAndSend(topic.getTopic(), chatDto);
   }
}
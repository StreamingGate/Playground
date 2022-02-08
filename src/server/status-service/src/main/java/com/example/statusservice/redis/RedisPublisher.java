//package com.example.statusservice.redis;
//
//import com.example.chatservice.model.chat.Chat;
//import com.example.chatservice.utils.RedisMessaging;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.data.redis.listener.ChannelTopic;
//import org.springframework.stereotype.Service;
//
//@Slf4j
//@Service
//public class RedisPublisher {
//
//   public void publish(ChannelTopic topic, Chat chat) {
//       log.info("topic:" + topic.getTopic());
//       RedisMessaging.publish(topic, chat);
//   }
//}
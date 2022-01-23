package com.example.chatservice.utils;

import com.example.chatservice.model.room.Room;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.stereotype.Component;

/**
 * <h1>RedisUtil</h1>
 * <pre>
 * Redis 메시징 기능을 분리한 유틸 클래스.
 *
 * 메시지 전송하는 클래스를 빈 자동주입하면서 순환참조 발생하는 것 방지
 * Ex.
 * SimpMessageSendingOperations.java
 * -> @EnableWebSocketMessageBroker 붙은 WebSocketConfig.java
 * -> StompHandler.java
 * -> RedisRoomRepository.java
 * -> SimpMessageSendingOperations.java
 * </pre>
 */
@Component
public class RedisMessaging {

    private static RedisTemplate<String, Object> redisTemplate;

    @Autowired
    public RedisMessaging(RedisTemplate<String, Object> redisTemplate){
        this.redisTemplate= redisTemplate;
    }

    public static void publish(ChannelTopic topic, Object object){
        redisTemplate.convertAndSend(topic.getTopic(), object);
    }

    public static String getPublishedMessage(Message message){
        return redisTemplate.getStringSerializer().deserialize(message.getBody());
    }

    public static HashOperations<String, String, Room> getOpsHashRoom(){
        return redisTemplate.opsForHash();
    }

}

package com.example.chatservice.controller;

import com.example.chatservice.dto.ChatDto;
import com.example.chatservice.redis.RedisPublisher;
import com.example.chatservice.redis.RedisRoomRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;


/**
 * <h1>ChatController</h1>
 * broker 역할을 합니다.(특정 topic에 publish된 메시지들을 subscriber에게 전송)
 */
@Slf4j
@RequiredArgsConstructor
@Controller
public class RedisPubSubController {

    private final RedisPublisher redisPublisher;
    private final RedisRoomRepository redisRoomRepository;

    @MessageMapping("/chat/message")
    public void message(ChatDto chatDto) throws Exception{
        log.info("ws message:" + chatDto.getMessage());
        redisRoomRepository.enter(chatDto.getRoomId());
        redisPublisher.publish(redisRoomRepository.getTopic(chatDto.getRoomId()), chatDto);
    }
}


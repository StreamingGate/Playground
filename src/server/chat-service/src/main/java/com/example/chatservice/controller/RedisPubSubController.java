package com.example.chatservice.controller;

import com.example.chatservice.model.chat.Chat;
import com.example.chatservice.model.chat.ChatType;
import com.example.chatservice.redis.RedisPublisher;
import com.example.chatservice.redis.RedisRoomRepository;

import com.example.chatservice.exception.ErrorResponse;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import static com.example.chatservice.exception.ErrorCode.C001;


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
    public void message(Chat chat) throws Exception
    {
        log.info("ws message:" + chat.getMessage());
        if(chat.getChatType().equals(ChatType.PINNED)){
            try{
                int pinnedCnt = redisRoomRepository.addPinnedChat(chat);
                log.info("pinnedCnt: " + pinnedCnt);
            }catch(RuntimeException e){
                e.printStackTrace();
                redisPublisher.publish(redisRoomRepository.getTopic(chat.getRoomId()),
                        new ErrorResponse(C001, C001.getMessage()));
            }
        }
        redisRoomRepository.enter(chat.getRoomId()); // FIXME: StompHandler
        redisPublisher.publish(redisRoomRepository.getTopic(chat.getRoomId()), chat);
    }
}


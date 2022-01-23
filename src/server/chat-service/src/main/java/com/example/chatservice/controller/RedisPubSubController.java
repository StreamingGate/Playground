package com.example.chatservice.controller;

import com.example.chatservice.exception.ErrorResponse;
import com.example.chatservice.model.chat.Chat;
import com.example.chatservice.model.chat.ChatType;
import com.example.chatservice.redis.RedisPublisher;
import com.example.chatservice.redis.RedisRoomRepository;
import com.example.chatservice.utils.ClientMessaging;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;

import static com.example.chatservice.exception.ErrorCode.C001;


/**
 * <h1>ChatController</h1>
 * broker 역할을 합니다.(특정 topic에 publish된 메시지들을 subscriber에게 전송)
 */
@Slf4j
@RequiredArgsConstructor
@Controller
public class RedisPubSubController {

    private static final String CHAT_DESTINATION="/topic/chat/room/";
    private final RedisPublisher redisPublisher;
    private final RedisRoomRepository redisRoomRepository;

    @MessageMapping("/chat/message/{roomId}")
    public void message(@DestinationVariable String roomId, Chat chat) throws Exception {
        log.info("ws message:" + chat.getMessage());
        try {
            if (chat.getChatType().equals(ChatType.PINNED)) {
                int pinnedCnt = redisRoomRepository.addPinnedChat(roomId, chat);
                log.info("pinnedCnt: " + pinnedCnt);
            }
            redisPublisher.publish(redisRoomRepository.getTopic(roomId), chat);
        } catch (IllegalArgumentException e) {
            log.info(e.getMessage());
            ClientMessaging.publish(CHAT_DESTINATION + roomId, new ErrorResponse(C001, C001.getMessage()));
        }
    }
}


package com.example.chatservice.controller;

import com.example.chatservice.dto.chat.ChatProduce;
import com.example.chatservice.dto.chat.ChatType;
import com.example.chatservice.redis.RedisRoomService;
import com.example.chatservice.utils.ClientMessaging;
import com.example.chatservice.utils.RedisMessaging;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.DestinationVariable;
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

    private static final String CHAT_DESTINATION="/topic/chat/room/";
    private final RedisRoomService redisRoomService;

    @MessageMapping("/chat/message/{roomId}")
    public void message(@DestinationVariable String roomId, ChatProduce chat) throws Exception{
        if (chat.getChatType().equals(ChatType.PINNED)) {
            redisRoomService.addPinnedChat(roomId, chat);
        }
        RedisMessaging.publish(redisRoomService.getOrAddTopic(roomId), chat);
    }
}

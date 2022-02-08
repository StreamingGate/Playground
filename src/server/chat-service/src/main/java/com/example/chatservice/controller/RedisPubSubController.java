package com.example.chatservice.controller;

import com.example.chatservice.exception.CustomChatException;
import com.example.chatservice.exception.ErrorResponse;
import com.example.chatservice.model.chat.ChatProduce;
import com.example.chatservice.model.chat.ChatType;
import com.example.chatservice.redis.RedisRoomService;
import com.example.chatservice.utils.ClientMessaging;
import com.example.chatservice.utils.RedisMessaging;
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
public class RedisPubSubController {    /* TODO: Scheduling 적용 */

    private static final String CHAT_DESTINATION="/topic/chat/room/";
    private static final String USER_CNT_DESTINATION="/topic/user-cnt/room/";
    private static final String ERROR_DESTINATION="/queue/errors";
    private final RedisRoomService redisRoomService;

    /* TODO: 일반 채팅, 채팅 고정 분리하기 */
    @MessageMapping("/chat/message/{roomId}")
    public void message(@DestinationVariable String roomId, ChatProduce chat) throws Exception{
        try {
            if (chat.getChatType().equals(ChatType.PINNED)) {
                int pinnedCnt = redisRoomService.addPinnedChat(roomId, chat);
                log.info("pinnedCnt: " + pinnedCnt);
            }
            RedisMessaging.publish(redisRoomService.getTopic(roomId), chat);
        } catch (CustomChatException e) {
            e.printStackTrace();
            ClientMessaging.publish(CHAT_DESTINATION + roomId, new ErrorResponse(C001, C001.getMessage()));
//            ClientMessaging.publishToUser("testuuid", ERROR_DESTINATION, new ErrorResponse(C001, C001.getMessage()));
        }
    }

    /** client에서 채팅방 나가기 직전에 보낸다 **/
    @MessageMapping("/user-cnt/room/{roomId}/exit")
    public void exit(@DestinationVariable String roomId) throws Exception{
        int userCnt = redisRoomService.exit(roomId);
        ClientMessaging.publish(USER_CNT_DESTINATION+roomId, userCnt);
    }

//    @MessageMapping("/chat/message/{roomId}/userCnt")
//    public void enter(@DestinationVariable String roomId) throws Exception{
//        int userCnt = redisRoomService.getUserCnt(roomId);
//        ClientMessaging.publish(CHAT_DESTINATION + roomId, userCnt);
//    }
}

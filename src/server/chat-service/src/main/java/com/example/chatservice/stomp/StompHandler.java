package com.example.chatservice.stomp;


import com.example.chatservice.redis.RedisRoomService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.stereotype.Component;

@Slf4j
@RequiredArgsConstructor
@Component
public class StompHandler implements ChannelInterceptor {

    private final RedisRoomService redisRoomService;

    @Override
    public void postSend(Message message, MessageChannel channel, boolean sent) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        String[] splited;
        String roomId;
        switch (accessor.getCommand()) {
            case SUBSCRIBE:
                splited = accessor.getDestination().split("/");
                if (splited[2].equals("chat")) {
                    roomId = splited[splited.length - 1];
                    log.info("subscribe destination: " + roomId);
                    redisRoomService.enter(roomId);
                }
                break;
            case UNSUBSCRIBE:
                log.info("unsubscribed....");
            case DISCONNECT: 
                /* disconnect() or 세션이 끊어졌을 때(페이지 이동, 브라우저 닫기 등) */
                log.info("disconnected....");
                break;
            default:
                break;
        }

    }
}
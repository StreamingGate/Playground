package com.example.statusservice.stomp;


import com.example.statusservice.redis.RedisUserService;
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

    private final RedisUserService redisUserService;

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
                    redisUserService.login(roomId);
                }
                break;
            case UNSUBSCRIBE:
                log.info("unsubscribed....");
            case DISCONNECT: //disconnect() or 세션이 끊어졌을 때(페이지 이동, 브라우저 닫기 등)
                // `destination` is not appeared
                log.info("disconnected....");
                break;
            default:
                break;
        }

    }
}
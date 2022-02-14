package com.example.chatservice.stomp;


import com.example.chatservice.exception.CustomChatException;
import com.example.chatservice.exception.ErrorCode;
import com.example.chatservice.redis.JwtService;
import com.example.chatservice.redis.RedisRoomService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.stereotype.Component;
import org.springframework.util.MultiValueMap;

@Slf4j
@RequiredArgsConstructor
@Component
public class StompHandler implements ChannelInterceptor {

    private final RedisRoomService redisRoomService;
    private final JwtService jwtService;

    /* DISCONNET 메시지의 경우 preSend로 처리해야 헤더로 전송된 값을 처리할 수 있음 */
    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) throws CustomChatException{
        log.info("Channel Interceptor");
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        String roomUuid;
        switch (accessor.getCommand()) {
            case CONNECT: /* JWT 검증 */
                String token = getUuidFromHeader(message, "token");
                log.info("[preSend connect] token=" + token);
                jwtService.validation(token);
                break;
            case DISCONNECT: /* 페이지 이동, 브라우저 닫기 포함 */
                String destination = accessor.getDestination();
                log.info("disconnect destination: " + destination);
                roomUuid = destination.substring(destination.lastIndexOf("/") + 1);
                log.info("disconnect roomUuid: " + roomUuid);
                String userUuid = getUuidFromHeader(message, "uuid");
                log.info("disconnect userUuid: " + userUuid);
                redisRoomService.exit(roomUuid, userUuid);
                break;
            default:
                break;
        }
        return message;
    }

    @Override
    public void postSend(Message message, MessageChannel channel, boolean sent) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        String roomUuid;
        switch (accessor.getCommand()) {
            case SUBSCRIBE:
                String destination = accessor.getDestination();
                roomUuid = destination.substring(destination.lastIndexOf("/") + 1);
                String userUuid = getUuidFromHeader(message, "uuid");
                log.info("disconnect destination: " + roomUuid+", uuid:" + userUuid);
                redisRoomService.enter(roomUuid, userUuid);
                break;
            default:
                break;
        }
    }

    private String getUuidFromHeader(Message<?> message, String key) {
        MessageHeaders headers = message.getHeaders();
        MultiValueMap<String, String> multiValueMap = headers.get(StompHeaderAccessor.NATIVE_HEADERS, MultiValueMap.class);
        String uuid = null;
        try {
            if (multiValueMap.containsKey(key)) {
                uuid = multiValueMap.getFirst(key);
            }
        } catch (NullPointerException e) {
            log.info("[ErrorCode.S002] " + ErrorCode.C002.getMessage());
//            throw new CustomStatusException(ErrorCode.S002);
        }
        return uuid;
    }
}
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
        String destination = accessor.getDestination();
        String roomUuid, userUuid;
        switch (accessor.getCommand()) {
            case CONNECT: /* JWT 검증 */
                String token = getValueFromHeader(message, "token");
                log.info("[preSend connect] token=" + token);
                if(jwtService.validation(token) == false) {
                    log.info("token 인증 실패");
                    throw new CustomChatException(ErrorCode.C003);
                } log.info("token 인증 성공");
                break;
            case SUBSCRIBE: /* postSend에서 수행시 NATIVE_HEADERS를 가져오지 못한다. */
                String topic = getSplited(destination,3);
                if(topic.equals("enter")) {
                    roomUuid = destination.substring(destination.lastIndexOf("/") + 1);
                    userUuid = getValueFromHeader(message, "uuid");
                    log.info("subscribe destination: " + roomUuid + ", uuid: " + userUuid);
                    if (roomUuid != null && userUuid != null) redisRoomService.enter(roomUuid, userUuid);
                }
                break;
            case DISCONNECT: /* 페이지 이동, 브라우저 닫기 포함 */
                roomUuid = getValueFromHeader(message, "roomUuid");
                log.info("disconnect roomUuid: " + roomUuid);
                userUuid = getValueFromHeader(message, "uuid");
                log.info("disconnect userUuid: " + userUuid);
                redisRoomService.exit(roomUuid, userUuid);
                break;
            default:
                break;
        }
        return message;
    }

    private String getSplited(String destination, int index){
        String[] splited = destination.split("/");
        String result = splited[index];
        return result;
    }

    private String getValueFromHeader(Message<?> message, String key) {
        MessageHeaders headers = message.getHeaders();
        MultiValueMap<String, String> multiValueMap = headers.get(StompHeaderAccessor.NATIVE_HEADERS, MultiValueMap.class);
        String value = null;
        try {
            if (multiValueMap.containsKey(key)) {
                value = multiValueMap.getFirst(key);
            }
        } catch(NullPointerException e){
            log.info("[ErrorCode.S002] " + ErrorCode.C002.getMessage());
        }
        return value;
    }
}
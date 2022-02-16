package com.example.statusservice.stomp;


import com.example.statusservice.exceptionhandler.customexception.CustomStatusException;
import com.example.statusservice.exceptionhandler.customexception.ErrorCode;
import com.example.statusservice.redis.JwtService;
import com.example.statusservice.redis.RedisUserService;
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

    private final RedisUserService redisUserService;
    private final JwtService jwtService;

    /* DISCONNET 메시지의 경우 preSend로 처리해야 헤더로 전송된 값을 처리할 수 있음 */
    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) throws CustomStatusException {
        log.info("Channel Interceptor");
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);

        String uuid;
        switch (accessor.getCommand()) {
            case CONNECT:
                String token = getValueFromHeader(message, "token");
                log.info("[preSend connect] token=" + token);
                if (jwtService.validation(token) == false) {
                    log.info("token 인증 실패");
                    throw new CustomStatusException(ErrorCode.S003);
                }
                log.info("token 인증 성공");
                break;
            case DISCONNECT: /* 페이지 이동, 브라우저 닫기 포함 */
                uuid = getValueFromHeader(message, "uuid");
                if (uuid != null) redisUserService.publishStatus(uuid, Boolean.FALSE);
                break;
            default:
                break;
        }
        return message;
    }

    @Override
    public void postSend(Message message, MessageChannel channel, boolean sent) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        String destination = accessor.getDestination();
        switch (accessor.getCommand()) {
            case SUBSCRIBE:
                String uuid = destination.substring(destination.lastIndexOf("/") + 1);
                if (uuid != null) redisUserService.publishStatus(uuid, Boolean.TRUE);
                break;
            default:
                break;
        }
    }

    private String getValueFromHeader(Message<?> message, String key) {
        MessageHeaders headers = message.getHeaders();
        MultiValueMap<String, String> multiValueMap = headers.get(StompHeaderAccessor.NATIVE_HEADERS, MultiValueMap.class);
        String value = null;
        try {
            if (multiValueMap.containsKey(key)) {
                value = multiValueMap.getFirst(key);
            }
        } catch (NullPointerException e) {
            log.info(key + "가 헤더에 없습니다." + ErrorCode.S002.getMessage());
        }
        return value;
    }
}
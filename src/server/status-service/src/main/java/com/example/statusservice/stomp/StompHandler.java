package com.example.statusservice.stomp;


import com.example.statusservice.exception.ErrorCode;
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

    /* DISCONNET 메시지의 경우 preSend로 처리해야 헤더로 전송된 값을 처리할 수 있음 */
    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        log.info("Channel Interceptor");
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        String uuid;
        switch (accessor.getCommand()) {
            case DISCONNECT: /* 페이지 이동, 브라우저 닫기 포함 */
                uuid = getUuidFromHeader(message);
                if(uuid!= null) redisUserService.publishStatus(uuid, Boolean.FALSE);
                break;
            default:
                break;
        }
        return message;
    }

    @Override
    public void postSend(Message message, MessageChannel channel, boolean sent) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        String destination;
        String uuid;
        switch (accessor.getCommand()) {
            case SUBSCRIBE:
                destination = accessor.getDestination();
                uuid = destination.substring(destination.lastIndexOf("/") + 1);
                if(uuid!= null) redisUserService.publishStatus(uuid, Boolean.TRUE);
                break;
            default:
                break;
        }
    }

    private String getUuidFromHeader(Message<?> message) {
        MessageHeaders headers = message.getHeaders();
        MultiValueMap<String, String> multiValueMap = headers.get(StompHeaderAccessor.NATIVE_HEADERS, MultiValueMap.class);
        String uuid = null;
        try {
            if (multiValueMap.containsKey("uuid")) {
                uuid = multiValueMap.getFirst("uuid");
            }
        } catch(NullPointerException e){
            log.info("[ErrorCode.S002] " + ErrorCode.S002.getMessage());
//            throw new CustomStatusException(ErrorCode.S002);
        }
        return uuid;
    }
}
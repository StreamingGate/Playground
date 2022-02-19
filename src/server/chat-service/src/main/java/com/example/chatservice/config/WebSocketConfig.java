package com.example.chatservice.config;


import com.example.chatservice.exceptionhandler.ErrorResponse;
import com.example.chatservice.exceptionhandler.customexception.CustomChatException;
import com.example.chatservice.stomp.StompHandler;
import com.example.chatservice.utils.RedisMessaging;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.Message;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.messaging.StompSubProtocolErrorHandler;

import java.io.IOException;

/**
 * <h1>WebSocketConfig</h1>
 * Stomp를 사용하기 위해 Broker를 구현한다.
 */
@RequiredArgsConstructor
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    private final RedisMessaging redisMessaging; // Warning: Must be declared before StompHandler.java
    private final StompHandler stompHandler;
    private final ObjectMapper objectMapper;

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic", "/queue");
        config.setApplicationDestinationPrefixes("/app");
        config.setUserDestinationPrefix("/user"); //특정 유저에게 보내는 사용자 path
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // ws 엔드포인트 등록
        registry.addEndpoint("/ws").setAllowedOriginPatterns("*")
                .withSockJS();
        registry.setErrorHandler(new StompSubProtocolErrorHandler(){
            @Override
            protected Message<byte[]> handleInternal(StompHeaderAccessor errorHeaderAccessor, byte[] errorPayload, Throwable cause, StompHeaderAccessor clientHeaderAccessor) {
                if(cause.getClass() == CustomChatException.class) {
                    errorHeaderAccessor.setMessage(null);
                    CustomChatException exception = (CustomChatException) cause;
                    ErrorResponse errorResponse = new ErrorResponse(exception.getErrorCode(), exception.getMessage());
                    try{
                        String errorString = objectMapper.writeValueAsString(errorResponse);
                        errorPayload = errorString.getBytes();
                    } catch(IOException e) {
                        e.printStackTrace();
                    }
                }
                return super.handleInternal(errorHeaderAccessor, errorPayload, cause, clientHeaderAccessor);
            }
        });
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(stompHandler);
    }
}
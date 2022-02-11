package com.example.chatservice.config;


import com.example.chatservice.stomp.StompHandler;
import com.example.chatservice.utils.RedisMessaging;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

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
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(stompHandler);
    }
}
package com.example.statusservice.config;


import com.example.statusservice.stomp.StompHandler;
import com.example.statusservice.utils.RedisMessaging;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
@Slf4j
@RequiredArgsConstructor
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    private final RedisMessaging redisMessaging; // Warning: Must be declared before StompHandler.java
    private final StompHandler stompHandler;

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic");
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        log.info("StompEndpointRegistry:"+registry);
        registry.addEndpoint("/ws").setAllowedOriginPatterns("*")
                .withSockJS();
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        log.info("ChannelRegistration:"+registration);
        log.info("StompHandler:" + stompHandler);
        registration.interceptors(stompHandler);
    }
}
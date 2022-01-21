package com.example.chatservice.config;


import com.example.chatservice.stomp.StompHandler;

import org.springframework.beans.factory.annotation.Autowired;
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
@EnableWebSocketMessageBroker
@Configuration
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Autowired
    private StompHandler stompHandler;

    // @Autowired
    // private RedisMessageListenerContainer redisMessageListenerContainer;

    // @Autowired
    // private RedisSubscriber redisSubscriber;

    
    // @Bean
    // public RedisRoomRepository redisRoomRepository() {
    //     return new RedisRoomRepository(redisMessageListenerContainer, redisSubscriber,
    //             new RedisTemplate<String, Object>());
    // }

    // @Bean
    // public StompHandler stompHandler() {
    //     return new StompHandler(redisRoomRepository());
    // }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic");
        config.setApplicationDestinationPrefixes("/app");
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
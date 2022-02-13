package com.example.chatservice.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Component;

/**
 * <h1>ClientMessaging</h1>
 * Client 메시징 기능을 분리한 유틸 클래스.
 */
@Component
public class ClientMessaging {

    private static SimpMessageSendingOperations messagingTemplate;

    @Autowired
    public ClientMessaging(SimpMessageSendingOperations messagingTemplate){
        this.messagingTemplate = messagingTemplate;
    }

    public static void publish(String destination, Object payload) {
        messagingTemplate.convertAndSend(destination, payload);
    }

    public static void publishToUser(String user, String destination, Object payload) {
        messagingTemplate.convertAndSendToUser(user, destination, payload);
    }
}

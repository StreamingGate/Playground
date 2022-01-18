package com.example.chatservice.controller;

import com.example.chatservice.dto.ChatMessage;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


/**
 * <h1>ChatController</h1>
 * broker 역할을 합니다.(특정 topic에 publish된 메시지들을 subscriber에게 전송)
 * <pre>
 *     * v0.1: WebSocketHandler로 처리(메시지를 room에 전달).
 *     * v0.2: @MessageMapping사용, 기존의 handler역할을 대체함.
 * </pre>
 *
 * @version 0.2
 */
@Slf4j
@RequiredArgsConstructor
@Controller
public class ChatController {

    private final SimpMessageSendingOperations messagingTemplate;

    
    @MessageMapping("/chat/message")
    public void message(ChatMessage message){
        log.info("ws message:" + message.getMessage());
        if(ChatMessage.MessageType.ENTER.equals(message.getType())){
            message.setMessage(message.getSender() + "님이 입장하셨습니다.");
        }
        log.info("to client : " + message.getRoomId()+ " " + message);
        messagingTemplate.convertAndSend("/topic/chat/room" + message.getRoomId(), message);
    }
}

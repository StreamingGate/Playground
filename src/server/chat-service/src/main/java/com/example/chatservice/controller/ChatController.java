package com.example.chatservice.controller;

import com.example.chatservice.dto.ChatDto;
import com.example.chatservice.service.ChatService;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


/**
 * <h1>ChatController</h1>
 * broker 역할을 합니다.(특정 topic에 publish된 메시지들을 subscriber에게 전송)
 */
@Slf4j
@RequiredArgsConstructor
@Controller
public class ChatController {

    private final ChatService chatService;
    private final SimpMessageSendingOperations messagingTemplate;
    
    @MessageMapping("/chat/message")
    public void message(ChatDto chatDto) throws Exception{
        log.info("ws message:" + chatDto.getMessage());
        chatService.create(chatDto);
        log.info("to client : " + chatDto.getRoomId()+ " " + chatDto.getMessage());
        
        messagingTemplate.convertAndSend("/topic/chat/room/" + chatDto.getRoomId(), chatDto);
    }
}

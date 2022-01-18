package com.example.chatservice.dto;

import java.util.UUID;

import lombok.Getter;
import lombok.ToString;


/**
 * <h1>ChatRoom</h1>
 * 채팅방입니다.
 * <pre>
 *     * v0.1: 세션 관리가 필요했음
 *     * v0.2: pub/sub구조로 세션 관리가 필요없어지면서 관리 필드 삭제
 * </pre>
 * @version 0.2
 */
@ToString
@Getter
public class ChatRoom {

    private final String roomId;
    private final String name;

    public ChatRoom(String name) {
        this.roomId = UUID.randomUUID().toString();
        this.name = name;
    }

//    public void handleActions(WebSocketSession session, ChatMessage chatMessage, ChatService chatService) {
//        if (chatMessage.getType().equals(ChatMessage.MessageType.ENTER)) {
//            sessions.add(session);
//            chatMessage.setMessage(chatMessage.getSender() + "님이 입장했습니다.");
//        }
//        sendMessage(chatMessage, chatService);
//    }
//
//    public <T> void sendMessage(T message, ChatService chatService) {
//        sessions.parallelStream().forEach(session -> chatService.sendMessage(session, message));
//    }
}
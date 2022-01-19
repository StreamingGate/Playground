package com.example.chatservice.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class MessageDto {

    private MessageType type;   // 메시지 타입
    private String roomId;      // 방번호
    private String sender;      // 메시지 보낸사람
    private String message;     // 메시지

    // 메시지 타입 : 입장, 채팅
    public enum MessageType {
        ENTER, TALK
    }

    public static MessageDto createEnterMessage(String roomId, String sender, String message) {
        return new MessageDto(MessageType.ENTER, roomId, sender, message);
    }

    public static MessageDto createTalkMessage(String roomId, String sender, String message) {
        return new MessageDto(MessageType.TALK, roomId, sender, message);
    }
}

package com.example.chatservice.entity.chat;


import java.time.LocalDateTime;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
@Document(collection = "chat")
public class Chat {

    @Id
    private String id;
    private String roomId;
    private String nickname;
    private SenderRole senderRole;
    private ChatType chatType;
    private String message;
    private LocalDateTime timestamp;

    @Builder
    public Chat(String nickname, String roomId, SenderRole senderRole, ChatType chatType, String message, LocalDateTime timestamp) {
        this.nickname = nickname;
        this.roomId = roomId;
        this.senderRole = senderRole;
        this.chatType = chatType;
        this.message = message;
        this.timestamp = timestamp;
    }
}

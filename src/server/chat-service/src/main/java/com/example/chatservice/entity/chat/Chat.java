package com.example.chatservice.entity.chat;


import com.example.chatservice.entity.chat.Role;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@RequiredArgsConstructor
@Getter
@Document(collection = "chat")
public class Chat {

    @Id
    private Long id;
    private String nickname;
    private Role role;
    private String message;
    private LocalDateTime timestamp;

    @Builder
    public Chat(String nickname, Role role, String message, LocalDateTime timestamp) {
        this.nickname = nickname;
        this.role = role;
        this.message = message;
        this.timestamp = timestamp;
    }
}

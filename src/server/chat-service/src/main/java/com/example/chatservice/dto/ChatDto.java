package com.example.chatservice.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import com.example.chatservice.entity.Chat;
import com.example.chatservice.entity.chat.Role;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;


@NoArgsConstructor
@Getter
public class ChatDto {

    private String nickname;
    private Role role;
    private String message;
    private LocalDateTime timestamp;

    public Chat toEntity() {
        return Chat.builder()
                .nickname(nickname)
                .role(role)
                .message(message)
                .timestamp(timestamp)
                .build();
    }
}
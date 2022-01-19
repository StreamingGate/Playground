package com.example.chatservice.dto;

import java.time.LocalDateTime;

import com.example.chatservice.entity.chat.Chat;
import com.example.chatservice.entity.chat.ChatType;
import com.example.chatservice.entity.chat.SenderRole;

import lombok.Getter;
import lombok.NoArgsConstructor;


@NoArgsConstructor
@Getter
public class ChatDto {

    private String roomId;
    private String nickname;
    private SenderRole senderRole;
    private ChatType chatType;          // TEST: STREAMER & (PINNED || NORMAL) , reverse
    private String message;
    private LocalDateTime timestamp;    // TODO: 혹시 dto받으면서 변경되진 않는지 확인

    public Chat toEntity() {
        return Chat.builder()
                .nickname(nickname)
                .senderRole(senderRole)
                .chatType(chatType)
                .message(message)
                .timestamp(timestamp)
                .build();
    }

}
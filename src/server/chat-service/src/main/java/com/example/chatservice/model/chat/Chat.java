package com.example.chatservice.model.chat;


import java.io.Serializable;
import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public class Chat  implements Serializable {

    private static final long serialVersionUID = 1234678977089006638L;

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

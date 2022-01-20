package com.example.chatservice.entity.chat;


import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.data.annotation.Id;

import java.io.Serializable;
import java.time.LocalDateTime;

@RequiredArgsConstructor
@Getter
public class Chat  implements Serializable {

    private static final long serialVersionUID = 1234678977089006638L;

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

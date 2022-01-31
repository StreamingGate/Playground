package com.example.chatservice.model.chat;


import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;

@NoArgsConstructor
@Data
public class Chat implements Serializable {

    private static final long serialVersionUID = 1234678977089006638L;

    private String roomId;  // RedisSubscriber.java onMessage에서 사용
    private String nickname;
    private SenderRole senderRole;
    private ChatType chatType;
    private String message;
    private LocalDateTime pstTime = ZonedDateTime.now(ZoneId.of("America/Los_Angeles")).toLocalDateTime();

    @Builder
    public Chat(String nickname, String roomId, SenderRole senderRole, ChatType chatType, String message) {
        this.nickname = nickname;
        this.roomId = roomId;
        this.senderRole = senderRole;
        this.chatType = chatType;
        this.message = message;
        this.pstTime = ZonedDateTime.now(ZoneId.of("America/Los_Angeles")).toLocalDateTime();
    }
}

package com.example.chatservice.model.chat;


import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.io.Serializable;

@RequiredArgsConstructor
@Getter
public class Chat implements Serializable {

    private static final long serialVersionUID = 1234678977089006638L;

    private String roomId;  // RedisSubscriber.java onMessage에서 사용
    private String nickname;
    private SenderRole senderRole;
    private ChatType chatType;
    private String message;

    @Builder
    public Chat(String nickname, String roomId, SenderRole senderRole, ChatType chatType, String message) {
        this.nickname = nickname;
        this.roomId = roomId;
        this.senderRole = senderRole;
        this.chatType = chatType;
        this.message = message;
    }
}

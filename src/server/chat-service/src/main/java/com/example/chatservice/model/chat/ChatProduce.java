package com.example.chatservice.model.chat;


import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import java.io.Serializable;
import java.time.LocalDateTime;

@NoArgsConstructor
@Data
public class ChatProduce implements Serializable {

    private static final long serialVersionUID = 1234678977089006638L;

    private String roomId;  // RedisSubscriber.java onMessage에서 사용
    @NonNull
    private String uuid;    // user's uuid
    private String nickname;
    private SenderRole senderRole;
    private ChatType chatType;
    private String message;
    private LocalDateTime timeStamp = LocalDateTime.now();


//    @Builder
//    public ChatProduce(String nickname, String roomId, String uuid, SenderRole senderRole, ChatType chatType,
//                       String message) {
//        this.roomId = roomId;
//        this.uuid = uuid;
//        this.nickname = nickname;
//        this.senderRole = senderRole;
//        this.chatType = chatType;
//        this.message = message;
//        this.timeStamp = LocalDateTime.now();
//    }
}

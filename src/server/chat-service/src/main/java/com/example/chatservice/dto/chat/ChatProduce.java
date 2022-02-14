package com.example.chatservice.dto.chat;


import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@NoArgsConstructor
@Data
public class ChatProduce implements Serializable {

    private static final long serialVersionUID = 1234678977089006638L;

    private Integer userCnt;// null (if use this dto for "enter" topic) or integer (if use this dto for "room" topic)

    private String roomUuid;  // RedisSubscriber.java onMessage에서 사용
    private String uuid;    // user's uuid
    private String nickname;
    private SenderRole senderRole;
    private ChatType chatType;
    private String message;
    private LocalDateTime timeStamp = LocalDateTime.now();

    public ChatProduce(String roomUuid, Integer userCnt){
        this.roomUuid = roomUuid;
        this.userCnt = userCnt;
    }
}

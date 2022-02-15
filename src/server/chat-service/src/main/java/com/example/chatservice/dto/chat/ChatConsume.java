package com.example.chatservice.dto.chat;


import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.io.Serializable;
import java.time.LocalDateTime;

@NoArgsConstructor
@Data
public class ChatConsume implements Serializable {

    private static final long serialVersionUID = 1234678977089006638L;
    private static final String PROFILE_PREFIX = "https://d8knntbqcc7jf.cloudfront.net/profiles/";

    private String roomUuid;  // RedisSubscriber.java onMessage에서 사용
    private String nickname;
    private SenderRole senderRole;
    private ChatType chatType;
    private String message;
    private String profileImage;
    private LocalDateTime timeStamp;


    @Builder
    public ChatConsume(ChatProduce chatProduce) {
        this.roomUuid = chatProduce.getRoomUuid();
        this.nickname = chatProduce.getNickname();
        this.senderRole = chatProduce.getSenderRole();
        this.chatType = chatProduce.getChatType();
        this.message = chatProduce.getMessage();
        this.profileImage= PROFILE_PREFIX + chatProduce.getUuid();
        this.timeStamp = chatProduce.getTimeStamp();
    }
}

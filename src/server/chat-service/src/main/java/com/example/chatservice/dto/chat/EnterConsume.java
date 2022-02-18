package com.example.chatservice.dto.chat;

import lombok.Data;
import lombok.NoArgsConstructor;


@NoArgsConstructor
@Data
public class EnterConsume {
    private String roomUuid; // destination
    private Integer userCnt;

    public EnterConsume(ChatProduce chatProduce){
        this.roomUuid = chatProduce.getRoomUuid();
        this.userCnt = chatProduce.getUserCnt();
    }
}

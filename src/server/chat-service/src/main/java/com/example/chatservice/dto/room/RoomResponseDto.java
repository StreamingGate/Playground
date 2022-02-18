package com.example.chatservice.dto.room;

import com.example.chatservice.dto.chat.ChatConsume;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class RoomResponseDto {

    private String uuid; // room's uuid
    private Integer userCnt;
    private ChatConsume pinnedChat;

    public RoomResponseDto(Room room){
        this.uuid = room.getUuid();
        this.userCnt = room.getUsers().size();
        this.pinnedChat = room.getPinnedChat();
    }
}

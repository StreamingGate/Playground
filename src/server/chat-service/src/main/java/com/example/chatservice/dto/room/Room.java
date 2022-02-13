package com.example.chatservice.dto.room;

import java.io.Serializable;

import com.example.chatservice.dto.chat.ChatConsume;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public class Room implements Serializable {

    private static final long serialVersionUID = 6494678977089006639L;

    private String uuid;
    private String hostUuid;
    private int userCnt;
    private ChatConsume pinnedChat;

    public Room(String uuid, String hostUuid) {
        this.uuid = uuid;
        this.hostUuid = hostUuid;
        this.userCnt = 0;
    }

    public void updatePinnedChat(ChatConsume pinnedChats){
        this.pinnedChat = pinnedChats;
    }

    public int addUser() {
        this.userCnt += 1;
        return this.userCnt;
    }

    public int removeUser() {
        this.userCnt -= 1;
        return this.userCnt;
    }
}
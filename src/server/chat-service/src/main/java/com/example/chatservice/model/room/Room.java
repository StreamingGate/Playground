package com.example.chatservice.model.room;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import com.example.chatservice.model.chat.ChatConsume;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public class Room implements Serializable {

    private static final long serialVersionUID = 6494678977089006639L;

    private String id;
    private String name;
    private int userCnt;
    private List<ChatConsume> pinnedChats = new ArrayList<>();

    public Room(String uuid) {
        this.id = uuid;
        this.name = uuid;
        this.userCnt = 0;
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
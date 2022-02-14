package com.example.chatservice.dto.room;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import com.example.chatservice.dto.chat.ChatConsume;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public class Room implements Serializable {

    private static final long serialVersionUID = 6494678977089006639L;

    private String uuid;
    private String hostUuid;
    private Set<String> users = new HashSet<>();
    private ChatConsume pinnedChat;

    public Room(String uuid, String hostUuid) {
        this.uuid = uuid;
        this.hostUuid = hostUuid;
    }

    public void updatePinnedChat(ChatConsume pinnedChats){
        this.pinnedChat = pinnedChats;
    }

    public int addUser(String uuid) {
        this.users.add(uuid);
        return users.size();
    }

    public int removeUser(String uuid) {
        this.users.remove(uuid);
        return users.size();
    }
}
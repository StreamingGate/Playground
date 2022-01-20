package com.example.chatservice.entity.room;

import com.example.chatservice.entity.chat.Chat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.data.annotation.Id;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Redis에 저장되는 객체들은 Serialize가능해야한다.
 */
@RequiredArgsConstructor
@Getter
public class Room implements Serializable {

    private static final long serialVersionUID = 6494678977089006639L;
    @Id
    private String id;
    private String name;
    private List<Chat> chats = new ArrayList<>();

    public Room(String name)  {
        this.id = UUID.randomUUID().toString();
        this.name = name;
    }
}
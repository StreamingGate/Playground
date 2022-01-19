package com.example.chatservice.entity.room;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.example.chatservice.entity.chat.Chat;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
@Document(collection = "room")
public class Room {

    @Id
    private String id = UUID.randomUUID().toString();
    private String name;
    private List<Chat> chats = new ArrayList<>();

    public Room(String name)  {
        this.id = UUID.randomUUID().toString();
        this.name = name;
    }
}
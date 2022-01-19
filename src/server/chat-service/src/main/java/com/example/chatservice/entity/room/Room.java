package com.example.chatservice.entity.room;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.UUID;

@RequiredArgsConstructor
@Getter
@Document
public class Room {

    @Id
    private String id = UUID.randomUUID().toString();
    private String name;

    public Room(String name)  {
        this.name = name;
    }
}
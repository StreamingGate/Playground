package com.example.chatservice.entity.room;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.util.UUID;

@RequiredArgsConstructor
@Getter
@Entity
public class Room {

    @Id
    private String id = UUID.randomUUID().toString();
    private String name;

    public Room(String name)  {
        this.id = UUID.randomUUID().toString();
        this.name = name;
    }
}
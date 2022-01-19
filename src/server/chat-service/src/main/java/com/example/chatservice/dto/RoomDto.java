package com.example.chatservice.dto;

import com.example.chatservice.entity.room.Room;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RoomDto {

    private String id;
    private String name;

    public static RoomDto from(Room room) {
        return new RoomDto(room.getId(), room.getName());
    }
}

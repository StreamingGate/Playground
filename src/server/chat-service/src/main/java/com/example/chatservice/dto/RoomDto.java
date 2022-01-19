package com.example.chatservice.dto;

import java.util.List;
import java.util.stream.Collectors;

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
    private List<ChatDto> chats;

    public static RoomDto from(Room room) {
        List<ChatDto> chats = room.getChats().stream()
        .map(chat -> ChatDto.from(chat)).collect(Collectors.toList());
        return new RoomDto(room.getId(), room.getName(), chats);
    }
}

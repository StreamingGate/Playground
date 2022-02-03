package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.Room.Room;
import lombok.Data;
import lombok.NonNull;

import java.time.LocalDateTime;

@Data
public class RoomResponseDto {
    private Long id;
    private String title;
    private String hostNickname;
    private String hostUuid;
    @NonNull
    private String uuid; // live, chat uuid
    private String thumbnail;
    private Category category;
    private LocalDateTime createdAt;

    public RoomResponseDto(Room room){
        this.id = room.getId();
        this.title = room.getTitle();
        this.hostNickname = room.getUser().getNickName();
        this.hostUuid = room.getUser().getUuid();
        this.uuid = room.getUuid();
        this.thumbnail = room.getThumbnail();
        this.category = room.getCategory();
        this.createdAt = room.getCreatedAt();
    }
}

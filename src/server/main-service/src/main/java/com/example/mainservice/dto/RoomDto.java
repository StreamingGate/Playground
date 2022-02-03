package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.Room.Room;
import com.sun.istack.NotNull;
import lombok.Data;
import org.modelmapper.ModelMapper;

import java.time.LocalDateTime;

@Data
public class RoomDto {
    private Long id;
    private String title;
    private String hostNickname;
    private String fileLink;
    private String thumbnail;
    private Category category;
    private LocalDateTime createdAt;
    @NotNull
    private String streamingId;
    @NotNull
    private String chatRoomId;

    public static RoomDto fromEntity(ModelMapper mapper, Room room){
        return mapper.map(room, RoomDto.class);
    }
}

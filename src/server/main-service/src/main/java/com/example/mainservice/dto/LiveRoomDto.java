package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.LiveRoom.LiveRoom;
import com.sun.istack.NotNull;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.modelmapper.ModelMapper;

import java.time.LocalDateTime;

@Data
public class LiveRoomDto {
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

    public static LiveRoomDto fromEntity(ModelMapper mapper, LiveRoom liveRoom){
        return mapper.map(liveRoom, LiveRoomDto.class);
    }
}

package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import com.sun.istack.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@NoArgsConstructor
@Setter
@Getter
public class LiveRoomDto {
    private Long id;
    private String title;
    private String hostNickname;
    private String thumbnail;
    private Category category;
    private LocalDateTime createdAt;
    @NotNull
    private String streamingId;
    @NotNull
    private String chatRoomId;
}

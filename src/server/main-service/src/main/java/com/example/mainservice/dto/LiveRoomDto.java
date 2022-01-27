package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import com.sun.istack.NotNull;

import java.time.LocalDateTime;

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

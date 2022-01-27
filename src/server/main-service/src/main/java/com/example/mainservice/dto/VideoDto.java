package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.Video.Video;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
public class VideoDto {

    private Long id;
    private String title;
    private String uploaderNickname;
    private Category category;
    private String thumbnail;
    private int hits;
    private LocalDateTime createdAt;

}

package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.Video.Video;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@NoArgsConstructor
@Setter
@Getter
public class VideoDto {

    private Long id;
    private String title;
    private String uploaderNickname;
    private int hits;
    private String thumbnail;
    private Category category;
    private LocalDateTime createdAt;

}

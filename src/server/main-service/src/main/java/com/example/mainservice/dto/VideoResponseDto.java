package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.Video.Video;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class VideoResponseDto {

    private Long id;
    private String title;
    private String uploaderNickname;
    private String uploaderProfileImage;
    private String fileLink;
    private int hits;
    private String thumbnail;
    private Category category;
    private LocalDateTime createdAt;

    public VideoResponseDto(Video video) {//, Long viewedProgress){
        this.id = video.getId();
        this.title = video.getTitle();
        this.uploaderNickname = video.getUser().getNickName();
        this.uploaderProfileImage = video.getUser().getProfileImage();
        this.hits = video.getHits();
        this.fileLink = video.getMetadata().getFileLink();
        this.thumbnail = video.getThumbnail();
        this.category = video.getCategory();
        this.createdAt = video.getCreatedAt();
//        this.viewedProgress = viewedProgress;
    }
}

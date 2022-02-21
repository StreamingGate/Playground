package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.Video.Video;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class VideoResponseDto {

    private Long id;
    private String title;
    private String uuid;
    private String uploaderUuid;
    private String uploaderNickname;
    private String uploaderProfileImage;
    private String fileLink;
    private int hits;
    private String thumbnail;
    private Category category;
    private LocalDateTime createdAt;

    /* TODO : viewedProgress 구현하면 추가하기 */
    public VideoResponseDto(Video video) {
        this.id = video.getId();
        this.title = video.getTitle();
        this.uuid = video.getUuid();
        this.uploaderUuid = video.getUser().getUuid();
        this.uploaderNickname = video.getUser().getNickName();
        this.uploaderProfileImage = video.getUser().getProfileImage();
        this.hits = video.getHits();
        this.fileLink = video.getMetadata().getFileLink();
        this.thumbnail = video.getThumbnail();
        this.category = video.getCategory();
        this.createdAt = video.getCreatedAt();
    }

    public VideoResponseDto(Long id){
        this.id = id;
    }
}

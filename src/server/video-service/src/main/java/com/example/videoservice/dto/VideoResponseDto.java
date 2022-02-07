package com.example.videoservice.dto;

import com.example.videoservice.entity.Category;
import com.example.videoservice.entity.Video.Video;
import com.example.videoservice.entity.ViewdHistory.ViewedHistory;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class VideoResponseDto {

    @JsonIgnore
    private static final String SHARE_URL = "/video-service/video/";
    // video
    private String title;
    private String content;
    private String videoUuid;
    private String streamingUrl;
    private String shareUrl;
    private Category category;
    private Integer hits;
    private Integer likeCnt;
    // uploader
    private String uploaderProfileImage;
    private Integer subscriberCnt;
    // my
    private Boolean liked;
    private Boolean disliked;

    public VideoResponseDto(Video video, String streamingUrl, ViewedHistory viewedHistory){
        this.title = video.getTitle();
        this.content = video.getContent();
        this.videoUuid = video.getUuid();
        this.streamingUrl = streamingUrl;
        this.shareUrl = SHARE_URL+video.getId();
        this.category = video.getCategory();
        this.hits = video.getHits();
        this.likeCnt = video.getLikeCnt();
        this.uploaderProfileImage = video.getUser().getProfileImage();
        this.subscriberCnt = video.getUser().getFriends().size();
        this.liked = viewedHistory.isLiked();
        this.disliked = viewedHistory.isDisliked();
    }
}

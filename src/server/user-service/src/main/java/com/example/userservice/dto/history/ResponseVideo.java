package com.example.userservice.dto.history;

import com.example.userservice.entity.Video.Video;
import com.example.userservice.entity.ViewdHistory.ViewedHistory;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ResponseVideo {
    private Long id;
    private String title;
    private String content;
    private String fileLink;
    private int hits;
    private String thumbnail;
    private String uploaderNickname;
    private LocalDateTime createdAt;
    private LocalDateTime likedAt;
    private LocalDateTime lastViewedAt;

    public ResponseVideo (ViewedHistory video) {
        this.id = video.getVideo().getId();
        this.title = video.getVideo().getTitle();
        this.content = video.getVideo().getContent();
        this.uploaderNickname = video.getUser().getNickName();
        this.hits = video.getVideo().getHits();
        this.fileLink = video.getVideo().getMetadata().getFileLink();
        this.thumbnail = video.getVideo().getThumbnail();
        this.likedAt = video.getLikedAt();
        this.lastViewedAt = video.getLastViewedAt();
    }

    public ResponseVideo (Video video) {
        this.id = video.getId();
        this.title = video.getTitle();
        this.content = video.getContent();
        this.fileLink = video.getMetadata().getFileLink();
        this.hits = video.getHits();
        this.thumbnail = video.getThumbnail();
        this.uploaderNickname = video.getUser().getNickName();
        this.createdAt = video.getCreatedAt();
    }
}

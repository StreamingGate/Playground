package com.example.mainservice.entity.ViewdHistory;

import com.example.mainservice.entity.User.UserEntity;
import com.example.mainservice.entity.Video.Video;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
@Entity
public class ViewedHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDateTime viewedProgress;

    private boolean liked = false;

    private boolean disliked = false;

    private LocalDateTime likedAt;

    private LocalDateTime lastViewedAt;

    @ManyToOne
    @JoinColumn(name = "video_id")
    private Video video;

    @ManyToOne
    @JoinColumn(name = "users_id")
    private UserEntity userEntity;

    public ViewedHistory(UserEntity userEntity, Video video) {
        this.userEntity = userEntity;
        this.video = video;
        userEntity.getViewedHistories().add(this);
        video.getViewedHistories().add(this);
    }

    public void setLiked(boolean liked) {
        this.liked = liked;
        this.likedAt = liked? LocalDateTime.now(): null;
    }

    public void setDisliked(boolean disliked) {
        this.disliked = disliked;
    }
}

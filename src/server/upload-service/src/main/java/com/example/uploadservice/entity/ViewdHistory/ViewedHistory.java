package com.example.uploadservice.entity.ViewdHistory;

import com.example.uploadservice.entity.RoomViewer.RoomViewer;
import com.example.uploadservice.entity.User.User;
import com.example.uploadservice.entity.Video.Video;
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

    private Long viewedProgress; // ms

    private boolean liked = false;

    private boolean disliked = false;

    private LocalDateTime likedAt;

    private LocalDateTime lastViewedAt;

    @ManyToOne
    @JoinColumn(name = "video_id")
    private Video video;

    @ManyToOne
    @JoinColumn(name = "users_id")
    private User user;

    public ViewedHistory(User user, Video video) {
        this.user = user;
        this.video = video;
    }

    public ViewedHistory(RoomViewer roomViewer, Video video){
        this.liked = roomViewer.isLiked();
        this.disliked = roomViewer.isDisliked();
        this.likedAt = roomViewer.getLikedAt();
        this.lastViewedAt = roomViewer.getLastViewedAt();
        this.user = roomViewer.getUser();
        this.video = video;
    }

    public void setLiked(boolean liked) {
        this.liked = liked;
        this.likedAt = liked? LocalDateTime.now(): null;
    }

    public void setDisliked(boolean disliked) {
        this.disliked = disliked;
    }
}

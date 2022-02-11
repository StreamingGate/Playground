package com.example.mainservice.entity.ViewdHistory;

import com.example.mainservice.entity.User.User;
import com.example.mainservice.entity.Video.Video;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
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

    @ColumnDefault(value = "CURRENT_TIMESTAMP")
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

    /* 좋아요 실행 또는 취소 (좋아요 누를 시 싫어요는 취소 된다.) */
    public void setLiked(boolean liked) {
        this.liked = liked;
        this.likedAt = liked? LocalDateTime.now(): null;
        if(this.liked == true){
            this.disliked = false;
            video.addLikeCnt(1);
        }
    }

    /* 싫어요 실행 또는 취소 (싫어요 누를 시 좋아요는 취소 된다.) */
    public void setDisliked(boolean disliked) {
        this.disliked = disliked;
        if(this.disliked == true){
            this.liked = false;
            video.addLikeCnt(-1);
        }
    }
}

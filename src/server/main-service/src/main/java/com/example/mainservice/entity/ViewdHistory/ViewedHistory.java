package com.example.mainservice.entity.ViewdHistory;

import com.example.mainservice.entity.User.User;
import com.example.mainservice.entity.Video.Video;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.apache.tomcat.jni.Local;
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

    /* for unit test */
    public ViewedHistory(boolean liked, boolean disliked, LocalDateTime likedAt) {
        this.liked = liked;
        this.disliked = disliked;
        this.likedAt =likedAt;
    }

    /* 좋아요 실행 또는 취소 (좋아요 누를 시 싫어요 효과는 취소 된다.) */
    public void setLiked(boolean liked) {

        /* 좋아요 값 변경시 likedAt, likeCnt이 변경된다 */
        if (this.liked == false && liked == true) {
            video.addLikeCnt(1);
            this.likedAt = LocalDateTime.now();
            this.disliked = false;
        } else if(this.liked == true && liked == false){
            video.addLikeCnt(-1);
            this.likedAt = null;
        }
        this.liked = liked;
    }

    /* 싫어요 실행 또는 취소 (싫어요 누를 시 좋아요 효과는 취소 된다.) */
    public void setDisliked(boolean disliked) {

        /* 반영하려는 값이 현재 값과 다를때만 값 적용한다. */
        if (this.disliked == false && disliked == true && this.liked == true) {
            setLiked(false);
        }
        this.disliked = disliked;
    }

    public void updateLastViewedAt(){
        this.lastViewedAt = LocalDateTime.now();
    }
}

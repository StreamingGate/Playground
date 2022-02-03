package com.example.mainservice.entity.LiveViewer;

import com.example.mainservice.entity.Live.Live;
import com.example.mainservice.entity.User.User;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
@Entity
public class LiveViewer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private boolean liked = false;

    private boolean disliked = false;

    private LocalDateTime likedAt;

    private Long lastViewedAt; // ms단위

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "live_room_id")
    private Live live;

    public LiveViewer(User user, Live live) {
        this.user = user;
        this.live = live;
        user.getLiveViewers().add(this);
        live.getLiveViewers().add(this);
    }

    public void setLiked(boolean liked) {
        this.liked = liked;
        this.likedAt = LocalDateTime.now();
    }

    public void setDisliked(boolean disliked) {
        this.disliked = disliked;
    }
}

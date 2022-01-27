package com.example.mainservice.entity.LiveViewer;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import com.example.mainservice.entity.LiveRoom.LiveRoom;
import com.example.mainservice.entity.User.UserEntity;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
@Entity
public class LiveViewer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(length=10)
    private Role role;

    private boolean liked = false;

    private boolean disliked = false;

    private LocalDateTime likedAt;

    private LocalDateTime lastViewedAt;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private UserEntity userEntity;

    @ManyToOne
    @JoinColumn(name = "live_room_id")
    private LiveRoom liveRoom;

    public LiveViewer(UserEntity userEntity, LiveRoom liveRoom) {
        this.userEntity = userEntity;
        this.liveRoom = liveRoom;
        userEntity.getLiveViewers().add(this);
        liveRoom.getLiveViewers().add(this);
    }

    public void setLiked(boolean liked) {
        this.liked = liked;
        this.likedAt = LocalDateTime.now();
    }

    public void setDisliked(boolean disliked) {
        this.disliked = disliked;
    }
}

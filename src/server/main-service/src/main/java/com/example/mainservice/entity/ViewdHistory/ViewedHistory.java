package com.example.mainservice.entity.ViewdHistory;

import java.time.LocalDateTime;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import com.example.mainservice.entity.User.UserEntity;
import com.example.mainservice.entity.Video.Video;

import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
@Entity
public class ViewedHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDateTime viewedProgress;
    
    private boolean like;
    
    private boolean dislike;
    
    private LocalDateTime likedAt;
    
    private LocalDateTime lastViewedAt;
    
    @ManyToOne
    @JoinColumn(name = "video_id")
    private Video video;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private UserEntity userEntity;

}

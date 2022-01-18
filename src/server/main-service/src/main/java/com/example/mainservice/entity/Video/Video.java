package com.example.mainservice.entity.Video;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.Metadata.Metadata;
import com.example.mainservice.entity.User.UserEntity;
import com.example.mainservice.entity.ViewdHistory.ViewedHistory;

import java.time.LocalDateTime;
import java.util.List;

@NoArgsConstructor
@Getter
@Entity
public class Video {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 100)
    private String title;

    @Column(length = 5000)
    private String content;

    private int liked;
    private int disliked;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private Category category;

    private int hits;

    private short reportCnt;

    private LocalDateTime createdAt;

    @ManyToOne
    @JoinColumn(name = "users_id")
    private UserEntity userEntity;

    @OneToMany( mappedBy = "video")
    private List<ViewedHistory> viewedHistories;

    @OneToOne
    @JoinColumn(name = "metadata_id")
    private Metadata metadata;
}

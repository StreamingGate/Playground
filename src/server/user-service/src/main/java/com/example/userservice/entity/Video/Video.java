package com.example.userservice.entity.Video;

import com.example.userservice.entity.Metadata.Metadata;
import com.example.userservice.entity.User.Category;
import com.example.userservice.entity.User.User;
import com.example.userservice.entity.ViewdHistory.ViewedHistory;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@NoArgsConstructor
@Getter
@Entity
public class Video {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length=36)
    private String uuid;

    @Column(length = 100)
    private String title;

    @Column(length = 5000)
    private String content;

    @Column(columnDefinition="TEXT")
    private String thumbnail;

    private int likeCnt;

    private int hits;

    private short reportCnt;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private Category category;

    private LocalDateTime createdAt;

    @ManyToOne
    @JoinColumn(name = "users_id")
    private User user;

    @OneToMany( mappedBy = "video")
    private List<ViewedHistory> viewedHistories;

    @OneToOne
    @JoinColumn(name = "metadata_id")
    private Metadata metadata;

    public Video(String title) {
        this.title = title;
    }
}

package com.example.uploadservice.entity.Video;

import com.example.uploadservice.entity.Category;
import com.example.uploadservice.entity.Metadata.Metadata;
import com.example.uploadservice.entity.User.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
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

//    @OneToMany( mappedBy = "video")
//    private List<ViewedHistory> viewedHistories;

    @OneToOne
    @JoinColumn(name = "metadata_id")
    private Metadata metadata;


    public Video(String title) {
        this.title = title;
    }

//    public void addReportCnt(int reportCnt){
//        if(reportCnt != 1 && reportCnt != -1) log.error("잘못된 신고 수가 업데이트됩니다. parameter:"+reportCnt);
//        this.reportCnt+=reportCnt;
//        if(this.reportCnt<0) this.reportCnt = 0;
//    }
//
//    public void addLikeCnt(int likeCnt){
//        if(likeCnt != 1 && likeCnt != -1) log.error("잘못된 좋아요 수가 업데이트됩니다. parameter:"+likeCnt);
//        this.likeCnt+=likeCnt;
//        if(this.likeCnt<0) this.likeCnt = 0;
//    }

    @Builder
    public Video(String title, String content, Category category,
                 String thumbnail, String uuid, User user) {
        this.title = title;
        this.content = content;
        this.category = category;
        this.thumbnail = thumbnail;
        this.uuid = uuid;
        this.user = user;
        this.likeCnt = 0;
        this.hits = 0;
        this.reportCnt = 0;
        this.createdAt = ZonedDateTime.now(ZoneId.of("America/Los_Angeles")).toLocalDateTime();
    }

    public void setMetadata(Metadata metadata) {
        this.metadata = metadata;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }
}

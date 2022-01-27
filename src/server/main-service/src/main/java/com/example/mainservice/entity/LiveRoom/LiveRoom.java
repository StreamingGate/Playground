package com.example.mainservice.entity.LiveRoom;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.LiveViewer.LiveViewer;
import com.example.mainservice.entity.User.UserEntity;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@NoArgsConstructor
@Getter
@Entity
public class LiveRoom {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 100)
    private String title;

    @Column(length = 5000)
    private String content;

    private String hostNickname;

    @Column(columnDefinition = "TEXT")
    private String thumbnail;

    private int likeCnt;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private Category category;

    private LocalDateTime createdAt;

    private short reportCnt;

    private String streamingId;

    private String chatRoomId;

    @ManyToOne
    @JoinColumn(name = "users_id")
    private UserEntity userEntity;

    @OneToMany(mappedBy = "liveRoom")
    private List<LiveViewer> liveViewers;

    public LiveRoom(String title) {
        this.title = title;
    }

    public void addReportCnt(int reportCnt){
        if(reportCnt != 1 || reportCnt != -1) throw new IllegalArgumentException("잘못된 신수가 업데이트됩니다.");
        this.reportCnt+=reportCnt;
    }

    public void addLikeCnt(int likeCnt){
        if(likeCnt != 1 || likeCnt != -1) throw new IllegalArgumentException("잘못된 좋아요 수가 업데이트됩니다.");
        this.likeCnt+=likeCnt;
    }
}

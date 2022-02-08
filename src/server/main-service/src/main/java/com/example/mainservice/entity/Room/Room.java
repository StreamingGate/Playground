package com.example.mainservice.entity.Room;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.RoomViewer.RoomViewer;
import com.example.mainservice.entity.User.User;
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
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 36)
    private String uuid;    // use for chat, room

    @Column(length = 36)
    private String hostUuid;

    @Column(length = 100)
    private String title;

    @Column(length = 5000)
    private String content;

    @Column(columnDefinition = "TEXT")
    private String thumbnail;

    private int likeCnt;

    private short reportCnt;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private Category category;

    private LocalDateTime createdAt;

    @ManyToOne
    @JoinColumn(name = "users_id")
    private User user;

    @OneToMany(mappedBy = "room")
    private List<RoomViewer> roomViewers;

    public Room(String title) {
        this.title = title;
    }

    public void addReportCnt(int reportCnt){
        if(reportCnt != 1 && reportCnt != -1) log.error("잘못된 신고 수가 업데이트됩니다. parameter:"+reportCnt);
        this.reportCnt+=reportCnt;
        if(this.reportCnt<0) this.reportCnt = 0;
    }

    public void addLikeCnt(int likeCnt){
        if(likeCnt != 1 && likeCnt != -1) log.error("잘못된 좋아요 수가 업데이트됩니다. parameter:"+likeCnt);
        this.likeCnt+=likeCnt;
        if(this.likeCnt<0) this.likeCnt = 0;
    }
}

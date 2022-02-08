package com.example.uploadservice.entity.Room;

import com.example.uploadservice.entity.Category;
import com.example.uploadservice.entity.RoomViewer.RoomViewer;
import com.example.uploadservice.entity.User.User;
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
}

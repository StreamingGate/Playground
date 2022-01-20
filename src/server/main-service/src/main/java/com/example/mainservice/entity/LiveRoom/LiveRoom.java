package com.example.mainservice.entity.LiveRoom;

import java.time.LocalDateTime;

import javax.persistence.*;

import com.example.mainservice.entity.Category;

import com.example.mainservice.entity.User.UserEntity;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
@Entity
public class LiveRoom {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(length=100)
    private String title;

    @Column(length=5000)
    private String content;

    @Column(length = 30)
    private String hostEmail;

    private int likeCnt;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private Category category;

    private LocalDateTime createdAt;

    private short reportCnt;

    private String streamingId;

    private String chatRoomId;

    @ManyToOne
    @JoinColumn(name="users_id")
    private UserEntity userEntity;
}

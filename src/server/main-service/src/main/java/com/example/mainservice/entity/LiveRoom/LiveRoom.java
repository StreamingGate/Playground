package com.example.mainservice.entity.LiveRoom;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.example.mainservice.entity.Category;

import lombok.Getter;
import lombok.NoArgsConstructor;

enum LiveRoomState {
    STREAMING,
    UPLOADING,
    COMPLETED;
}
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

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private LiveRoomState state;

    private LocalDateTime createdAt;

    private short reportCnt;

    private String streamingId;

    private String chatRoomId;
}

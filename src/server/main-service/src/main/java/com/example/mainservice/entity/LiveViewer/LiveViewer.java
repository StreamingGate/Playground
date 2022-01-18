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

    private boolean liked;

    @Enumerated(EnumType.STRING)
    @Column(length=7)
    private LiveViewerState state;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private UserEntity userEntity;

    @ManyToOne
    @JoinColumn(name = "live_room_id")
    private LiveRoom liveRoom;
}

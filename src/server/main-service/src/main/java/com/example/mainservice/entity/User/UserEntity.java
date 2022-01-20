package com.example.mainservice.entity.User;

import java.time.LocalDate;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

import com.example.mainservice.entity.Friend.Friend;
import com.example.mainservice.entity.LiveRoom.LiveRoom;
import com.example.mainservice.entity.LiveViewer.LiveViewer;
import com.example.mainservice.entity.Video.Video;
import com.example.mainservice.entity.ViewdHistory.ViewedHistory;

import org.hibernate.annotations.ColumnDefault;

import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
@Entity(name = "users")
public class UserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true)
    private String email;
    
    @Column(length = 36)
    private String uuid;
    
    @Column(length = 61)
    private String pwd;
    
    @Column(length = 30)
    private String name;
    
    @Column
    private String nickName;
    
    @Column(columnDefinition="TEXT")
    private String profileImage;
    
    @Column
    @Enumerated(EnumType.STRING)
    private UserState state;
    
    @Column(nullable = false,updatable = false,insertable = false)
    @ColumnDefault("CURRENT_TIMESTAMP")
    private LocalDate createdAt;
    
    @Column
    private LocalDate modifiedAt;
    
    @Column
    private LocalDate deletedAt;
    
    @Column
    private String timeZone;
    
    @Column
    private LocalDate lastAt;
    
    @OneToMany(mappedBy = "userEntity")
    private List<LiveViewer> viewers;

    @OneToMany(mappedBy = "userEntity")
    private List<Video> videos;
    
    @OneToMany(mappedBy = "userEntity")
    private List<ViewedHistory> viewedHistories;
    
    @OneToMany(mappedBy = "userEntity")
    private List<Friend> friends;

    @OneToMany(mappedBy="userEntity")
    private List<LiveRoom> liveRooms;

}

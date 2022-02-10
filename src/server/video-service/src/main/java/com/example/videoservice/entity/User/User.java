package com.example.videoservice.entity.User;

import com.example.videoservice.entity.Video.Video;
import com.example.videoservice.entity.ViewdHistory.ViewedHistory;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.annotations.ColumnDefault;
import javax.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

@Slf4j
@NoArgsConstructor
@Getter
@Entity(name = "users")
public class User {
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

    @Column(columnDefinition = "TEXT")
    private String profileImage;

    @Column
    @Enumerated(EnumType.STRING)
    private UserState state;

    @Column(nullable = false, updatable = false, insertable = false)
    @ColumnDefault("CURRENT_TIMESTAMP")
    private LocalDate createdAt;

    @Column
    @ColumnDefault(value = "CURRENT_TIMESTAMP")
    private LocalDate modifiedAt;

    @Column
    private LocalDate deletedAt;

    @Column
    private String timeZone;

    @Column
    private LocalDate lastAt;

//    @OneToMany(mappedBy = "user")
//    private List<RoomViewer> roomViewers = new LinkedList<>();

    @OneToMany(mappedBy = "user")
    private List<Video> videos = new LinkedList<>();

    @OneToMany(mappedBy = "user")
    private List<ViewedHistory> viewedHistories = new LinkedList<>();

//    @OneToMany(mappedBy = "user")
//    private List<Room> rooms = new ArrayList<>();

//    @OneToMany(mappedBy = "user")
//    private List<Notification> notifications = new LinkedList<>();
//
//    @OneToMany(mappedBy = "user")
//    private List<FriendWait> friendWaits = new LinkedList<>();

    /**
     * =============Friend=============
     **/
    @ManyToMany
    @JoinTable(
            name = "friend",
            joinColumns = @JoinColumn(name = "users_id"),
            inverseJoinColumns = @JoinColumn(name = "friend_id")
    )
    private List<User> friends = new ArrayList<>();

    @ManyToMany(mappedBy = "friends") //나를 친구로 추가한 사람들
    private List<User> beFriend = new ArrayList<>();
    /**
     * ================================
     **/
}

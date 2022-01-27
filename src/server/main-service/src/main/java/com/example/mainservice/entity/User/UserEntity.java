package com.example.mainservice.entity.User;

import com.example.mainservice.entity.FriendWait.FriendWait;
import com.example.mainservice.entity.LiveRoom.LiveRoom;
import com.example.mainservice.entity.LiveViewer.LiveViewer;
import com.example.mainservice.entity.Notification.Notification;
import com.example.mainservice.entity.Video.Video;
import com.example.mainservice.entity.ViewdHistory.ViewedHistory;
import com.example.mainservice.exceptionHandler.customexception.CustomMainException;
import com.example.mainservice.exceptionHandler.customexception.ErrorCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.*;

@Slf4j
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

    @Column(columnDefinition = "TEXT")
    private String profileImage;

    @Column
    @Enumerated(EnumType.STRING)
    private UserState state;

    @Column(nullable = false, updatable = false, insertable = false)
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
    private List<LiveViewer> liveViewers = new LinkedList<>();

    @OneToMany(mappedBy = "userEntity")
    private List<Video> videos = new LinkedList<>();

    @OneToMany(mappedBy = "userEntity")
    private List<ViewedHistory> viewedHistories = new LinkedList<>();

    @OneToMany(mappedBy = "userEntity")
    private List<LiveRoom> liveRooms = new ArrayList<>();

    @OneToMany(mappedBy = "userEntity")
    private List<Notification> notifications = new LinkedList<>();

    @OneToMany(mappedBy = "userEntity")
    private List<FriendWait> friendWaits = new LinkedList<>();

    /**
     * =============Friend=============
     **/
    @ManyToMany
    @JoinTable(
            name = "friend",
            joinColumns = @JoinColumn(name = "users_id"),
            inverseJoinColumns = @JoinColumn(name = "friend_id")
    )
    private Set<UserEntity> friends = new HashSet<>();

    @ManyToMany(mappedBy = "friends") //나를 친구로 추가한 사람들
    private Set<UserEntity> beFriend = new HashSet<>();
    /**
     * ================================
     **/

    public void addFriend(UserEntity target) throws CustomMainException {
        if (target == null || target == this) return;
        if (friends.contains(target)) throw new CustomMainException(ErrorCode.F003);
        this.friends.add(target);
        target.getFriends().add(this);
    }

    public void deleteFriend(UserEntity target) throws CustomMainException {
        if (target == null || target == this) return;
        if (!friends.contains(target)) throw new CustomMainException(ErrorCode.F004);
        this.friends.remove(target);
        target.getFriends().remove(this);
    }
}

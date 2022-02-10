package com.example.mainservice.entity.User;

import com.example.mainservice.entity.FriendWait.FriendWait;
import com.example.mainservice.entity.Room.Room;
import com.example.mainservice.entity.RoomViewer.RoomViewer;
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

    @Column(columnDefinition = "MEDIUMBLOB")
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

    @OneToMany(mappedBy = "user")
    private List<RoomViewer> roomViewers = new LinkedList<>();

    @OneToMany(mappedBy = "user")
    private List<Video> videos = new LinkedList<>();

    @OneToMany(mappedBy = "user")
    private List<ViewedHistory> viewedHistories = new LinkedList<>();

    @OneToMany(mappedBy = "user")
    private List<Room> rooms = new ArrayList<>();

    @OneToMany(mappedBy = "user")
    private List<Notification> notifications = new LinkedList<>();

    @OneToMany(mappedBy = "user")
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
    private List<User> friends = new ArrayList<>();

    @ManyToMany(mappedBy = "friends") //나를 친구로 추가한 사람들
    private List<User> beFriend = new ArrayList<>();
    /**
     * ================================
     **/

    public void addFriend(User target) throws CustomMainException {
        if (target == null || target == this) return;
        if (friends.contains(target)) throw new CustomMainException(ErrorCode.F003);
        this.friends.add(target);
        target.getFriends().add(this);
    }

    public void deleteFriend(User target) throws CustomMainException {
        if (target == null || target == this) return;
        if (!friends.contains(target)) throw new CustomMainException(ErrorCode.F004);
        this.friends.remove(target);
        target.getFriends().remove(this);
    }
}

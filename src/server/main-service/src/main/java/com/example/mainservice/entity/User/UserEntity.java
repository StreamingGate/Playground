package com.example.mainservice.entity.User;

import com.example.mainservice.entity.FriendWait.FriendWait;
import com.example.mainservice.entity.LiveRoom.LiveRoom;
import com.example.mainservice.entity.LiveViewer.LiveViewer;
import com.example.mainservice.entity.Notification.Notification;
import com.example.mainservice.entity.Video.Video;
import com.example.mainservice.entity.ViewdHistory.ViewedHistory;
import com.example.mainservice.exceptionHandler.customexception.CustomMainException;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;

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
    private List<LiveViewer> liveViewers;

    @OneToMany(mappedBy = "userEntity")
    private List<Video> videos;

    @OneToMany(mappedBy = "userEntity")
    private List<ViewedHistory> viewedHistories;

    @OneToMany(mappedBy = "userEntity")
    private List<LiveRoom> liveRooms;

    @OneToMany(mappedBy = "userEntity")
    private List<Notification> notifications;

    @OneToMany(mappedBy = "userEntity")
    private List<FriendWait> friendWaits;

    /**=============Friend=============**/
    @ManyToOne
    @JoinColumn(name = "friend_id")
    private UserEntity friend; //friends들이 나를 참조

    @OneToMany(mappedBy = "friend")
    private List<UserEntity> friends;
    /**================================**/

    public void addFriend(UserEntity target) {
        if(target==null || target==this || friends.contains(target)) throw new IllegalArgumentException();
        this.friends.add(target);
        target.getFriends().add(this);
    }

    public void deleteFriend(UserEntity target) {
        if(target==null || target==this || !friends.contains(target)) throw new IllegalArgumentException();
        this.friends.remove(target);
        target.getFriends().remove(this);
    }
}

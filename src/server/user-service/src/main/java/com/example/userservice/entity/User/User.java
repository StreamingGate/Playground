package com.example.userservice.entity.User;

import com.example.userservice.dto.user.RegisterUser;
import com.example.userservice.dto.user.RequestMyinfo;
import com.example.userservice.entity.RoomViewer.RoomViewer;
import com.example.userservice.entity.Video.Video;
import com.example.userservice.entity.ViewdHistory.ViewedHistory;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.LinkedList;
import java.util.List;

@NoArgsConstructor
@Getter
@Entity(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;

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
    @ColumnDefault(value = "CURRENT_TIMESTAMP")
    private LocalDateTime createdAt;

    @Column
    @ColumnDefault(value = "CURRENT_TIMESTAMP")
    private LocalDateTime modifiedAt;

    @Column
    private LocalDateTime deletedAt;

    @Column
    private String timeZone;

    @Column
    @ColumnDefault(value = "CURRENT_TIMESTAMP")
    private LocalDateTime lastAt;

    @OneToMany(mappedBy = "user")
    private List<RoomViewer> roomViewers = new LinkedList<>();

    @OneToMany(mappedBy = "user")
    private List<Video> videos = new LinkedList<>();

    @OneToMany(mappedBy = "user")
    private List<ViewedHistory> viewedHistories = new LinkedList<>();

    @Builder
    public User(String email, String uuid, String pwd, String name, String nickName, String profileImage, UserState state) {
        this.email = email;
        this.uuid = uuid;
        this.pwd = pwd;
        this.name = name;
        this.nickName = nickName;
        this.profileImage = profileImage;
        this.state = state;
    }

    public static User create(RegisterUser userDto, String uuid, String pwd) {
        return User.builder()
                .email(userDto.getEmail())
                .uuid(uuid)
                .pwd(pwd)
                .name(userDto.getName())
                .nickName(userDto.getNickName())
                .profileImage(userDto.getProfileImage())
                .state(UserState.STEADY)
                .build();
    }

    public void update(RequestMyinfo requestDto, LocalDateTime modifiedAt) {
        this.nickName = requestDto.getNickName() == null ? nickName : requestDto.getNickName();
        this.profileImage = requestDto.getProfileImage() == null ? profileImage : requestDto.getProfileImage();
        this.modifiedAt = modifiedAt;
    }

    public void updatePwd(String bcryptPwd, LocalDate modifiedAt) {
        this.pwd = bcryptPwd;
    }

    public void delete(LocalDateTime deletedAt) {
        this.deletedAt = deletedAt;
        this.state = UserState.QUIT;
    }
}

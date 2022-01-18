package com.example.userservice.entity.User;

import com.example.userservice.dto.RegisterUser;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import javax.persistence.*;
import java.time.LocalDate;

@NoArgsConstructor
@Getter
@Entity(name = "users")
public class UserEntity {
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

    @Column
    private String profileImage;

    @Column
    @Enumerated(EnumType.STRING)
    private UserState state;

    @Column(nullable = false, updatable = false, insertable = false)
    @ColumnDefault(value = "CURRENT_TIMESTAMP")
    private LocalDate createdAt;

    @Column
    private LocalDate modifiedAt;

    @Column
    private LocalDate deletedAt;

    @Column
    private String timeZone;

    @Column
    private  LocalDate lastAt;

    @Builder
    public UserEntity(String email,String uuid,String pwd,String name,String nickName,String profileImage,UserState state) {
        this.email = email;
        this.uuid = uuid;
        this.pwd = pwd;
        this.name = name;
        this.nickName = nickName;
        this.profileImage = profileImage;
        this.state = state;
    }

    public static UserEntity create(RegisterUser userDto,String uuid,String pwd) {
        return UserEntity.builder()
                .email(userDto.getEmail())
                .uuid(uuid)
                .pwd(pwd)
                .name(userDto.getName())
                .nickName(userDto.getNickName())
                .profileImage(userDto.getProfileImage())
                .state(UserState.STEADY)
                .build();
    }

    public void update(RegisterUser requestDto, LocalDate modifiedAt,String ecryptpwd) {
        this.nickName = requestDto.getNickName() == null ? nickName : requestDto.getNickName();
        this.pwd = ecryptpwd == null ? pwd : ecryptpwd;
        this.profileImage = requestDto.getProfileImage() == null ? profileImage : requestDto.getProfileImage();
        this.modifiedAt = modifiedAt;
    }

    public void delete(LocalDate deletedAt) {
        this.deletedAt = deletedAt;
        this.state = UserState.QUIT;
    }
}

package com.example.userservice.entity.User;

import com.example.userservice.dto.UserDto;
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

    @Column(length = 30,unique = true)
    private String email;

    @Column
    private String uuid;

    @Column
    private String pwd;

    @Column
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

    @Column(nullable = true, updatable = true, insertable = true)
    private LocalDate modifiedAt;

    @Column(nullable = true, updatable = true, insertable = true)
    private  LocalDate deletedAt;

    @Column(nullable = true, updatable = true, insertable = true)
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

    public static UserEntity createUser(UserDto userDto) {
        return UserEntity.builder()
                .email(userDto.getEmail())
                .uuid(userDto.getUserId())
                .pwd(userDto.getEncryptedPwd())
                .name(userDto.getName())
                .nickName(userDto.getNickName())
                .profileImage(userDto.getProfileImage())
                .state(UserState.STEADY)
                .build();
    }

    public void updateUser(UserDto requestDto, LocalDate modifiedAt) {
        this.nickName = requestDto.getNickName() == null ? requestDto.getNickName() : nickName;
        this.pwd = requestDto.getEncryptedPwd() == null ? requestDto.getEncryptedPwd() : pwd;
        this.profileImage = requestDto.getProfileImage() == null ? requestDto.getProfileImage() : profileImage;
        this.modifiedAt = modifiedAt;
    }

    public void deleteUser(LocalDate deletedAt) {
        this.deletedAt = deletedAt;
        this.state = UserState.QUIT;
    }
}

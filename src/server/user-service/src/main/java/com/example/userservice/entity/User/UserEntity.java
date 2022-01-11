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
    private String userId;

    @Column
    private String encryptedPwd;

    @Column
    private String userName;

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

    @Builder
    public UserEntity(String email,String userId,String encryptedPwd,String name,String nickName,String profileImage,UserState state) {
        this.email = email;
        this.userId = userId;
        this.encryptedPwd = encryptedPwd;
        this.userName = name;
        this.nickName = nickName;
        this.profileImage = profileImage;
        this.state = state;
    }

    public static UserEntity createUser(UserDto userDto) {
        return UserEntity.builder()
                .email(userDto.getEmail())
                .userId(userDto.getUserId())
                .encryptedPwd(userDto.getEncryptedPwd())
                .name(userDto.getName())
                .nickName(userDto.getNickName())
                .profileImage(userDto.getProfileImage())
                .state(UserState.STEADY)
                .build();
    }

    public static UserEntity updateUser(UserDto userDto) {
        return UserEntity.builder()
                .nickName(userDto.getNickName())
                .encryptedPwd(userDto.getEncryptedPwd())
                .profileImage(userDto.getProfileImage())
                .build();
    }
}

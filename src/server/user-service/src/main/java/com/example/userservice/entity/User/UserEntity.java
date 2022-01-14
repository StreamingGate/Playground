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

    @Column(unique = true)
    private String email;

    @Column(length = 36,columnDefinition = "varchar(36)")
    private String uuid;

    @Column(length = 61,columnDefinition = "varchar(61)")
    private String pwd;

    @Column(length = 30,columnDefinition = "varchar(30)")
    private String name;

    @Column(columnDefinition = "varchar(8)")
    private String nickName;

    @Column(columnDefinition = "TEXT")
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

    @Column(columnDefinition = "varchar(50)")
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

    public static UserEntity createUser(UserDto userDto) {
        return UserEntity.builder()
                .email(userDto.getEmail())
                .uuid(userDto.getUuid())
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

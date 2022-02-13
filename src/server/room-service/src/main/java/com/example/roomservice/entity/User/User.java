package com.example.roomservice.entity.User;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import javax.persistence.*;
import java.time.LocalDate;

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
    private LocalDate createdAt;

    @Column
    @ColumnDefault(value = "CURRENT_TIMESTAMP")
    private LocalDate modifiedAt;

    @Column
    private LocalDate deletedAt;

    @Column
    private String timeZone;

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
}

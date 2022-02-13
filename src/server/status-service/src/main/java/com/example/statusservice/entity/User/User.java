package com.example.statusservice.entity.User;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import javax.management.Notification;
import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import org.hibernate.annotations.ColumnDefault;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisHash;

@Slf4j
@NoArgsConstructor
@Getter
@Entity(name = "users")
public class User implements Serializable {

    private static final long serialVersionUID = 4444478977089006638L;

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

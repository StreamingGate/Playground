package com.example.mainservice.entity.Notification;

import com.example.mainservice.entity.User.UserEntity;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@NoArgsConstructor
@Getter
@Entity
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.ORDINAL)
    private NotiType notiType;

    private String content; // json type

    @ManyToOne
    @JoinColumn(name="users_id")
    private UserEntity userEntity;

    public enum NotiType{
        STREAMING,      // "{\"sender\":%s, \"title\":%s, \"roomId\":%s}"
        FRIEND_REQUEST, // "{\"sender\":%s}"
        LIKES;          // "{\"sender\":%s, \"title\":%s, \"videoId\":%s}"
    }
}

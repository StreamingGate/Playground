package com.example.mainservice.entity.Notification;

import com.example.mainservice.entity.LiveRoom.LiveRoom;
import com.example.mainservice.entity.User.UserEntity;
import com.example.mainservice.entity.Video.Video;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.LinkedList;
import java.util.List;

@NoArgsConstructor
@Getter
@Entity
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private NotiType notiType;

    private String content; // json type

    @ManyToOne
    @JoinColumn(name="users_id")
    private UserEntity userEntity;

    public static Notification createFriendRequest(UserEntity sender, UserEntity target){
        return Notification.builder()
                .notiType(NotiType.FRIEND_REQUEST)
                .content(NotiType.getFriendRequestContent(sender))
                .userEntity(target)
                .build();
    }

    public static List<Notification> createStreaming(UserEntity sender, LiveRoom liveRoom){
        List<Notification> notifications = new LinkedList<>();
        for(UserEntity friend : sender.getFriends() ) {
            Notification.builder()
                    .notiType(NotiType.STREAMING)
                    .content(NotiType.getStreamingContent(sender, liveRoom))
                    .userEntity(friend)
                    .build();
        }
        return notifications;
    }

    public static Notification createLikes(UserEntity user, Video video){
        return Notification.builder()
                .notiType(NotiType.LIKES)
                .content(NotiType.getLikesContent(user, video))
                .userEntity(video.getUserEntity())
                .build();
    }

    @Builder
    public Notification(NotiType notiType, String content, UserEntity userEntity){
        this.notiType = notiType;
        this.content = content;
        this.userEntity = userEntity;
    }
}

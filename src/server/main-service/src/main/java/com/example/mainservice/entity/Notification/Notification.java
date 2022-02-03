package com.example.mainservice.entity.Notification;

import com.example.mainservice.entity.Room.Room;
import com.example.mainservice.entity.User.User;
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
    private User user;

    public static Notification createFriendRequest(User sender, User target){
        return Notification.builder()
                .notiType(NotiType.FRIEND_REQUEST)
                .content(NotiType.getFriendRequestContent(sender))
                .user(target)
                .build();
    }

    public static List<Notification> createStreaming(User sender, Room room){
        List<Notification> notifications = new LinkedList<>();
        for(User friend : sender.getFriends() ) {
            Notification.builder()
                    .notiType(NotiType.STREAMING)
                    .content(NotiType.getStreamingContent(sender, room))
                    .user(friend)
                    .build();
        }
        return notifications;
    }

    public static Notification createLikes(User user, Video video){
        return Notification.builder()
                .notiType(NotiType.LIKES)
                .content(NotiType.getLikesContent(user, video))
                .user(video.getUser())
                .build();
    }

    @Builder
    public Notification(NotiType notiType, String content, User user){
        this.notiType = notiType;
        this.content = content;
        this.user = user;
    }
}

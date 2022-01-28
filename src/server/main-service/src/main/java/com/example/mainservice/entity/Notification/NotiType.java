package com.example.mainservice.entity.Notification;

import com.example.mainservice.entity.LiveRoom.LiveRoom;
import com.example.mainservice.entity.User.UserEntity;
import com.example.mainservice.entity.Video.Video;
import lombok.Getter;

@Getter
public enum NotiType {
    STREAMING("{\"sender\":\"%s\", \"profileImage\":\"%s\", \"title\":\"%s\", \"roomId\":%d}"),
    FRIEND_REQUEST("{\"sender\":\"%s\", \"profileImage\":\"%s\"}"),
    LIKES("{\"sender\":\"%s\", \"profileImage\":\"%s\", \"title\":\"%s\", \"videoId\":%d}");

    private String template;

    NotiType(String template) {
        this.template = template;
    }

    public static String getStreamingContent(UserEntity user, LiveRoom liveRoom) {
        return String.format(STREAMING.getTemplate(), user.getNickName(), user.getProfileImage(),
                liveRoom.getTitle(), liveRoom.getId());
    }

    public static String getFriendRequestContent(UserEntity user) {
        return String.format(FRIEND_REQUEST.getTemplate(), user.getNickName(), user.getProfileImage());
    }

    public static String getLikesContent(UserEntity user, Video video) {
        return String.format(LIKES.getTemplate(), user.getNickName(), user.getProfileImage(),
                video.getTitle(), video.getId());
    }
}
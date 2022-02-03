package com.example.mainservice.entity.Notification;

import com.example.mainservice.entity.Live.Live;
import com.example.mainservice.entity.User.User;
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

    public static String getStreamingContent(User user, Live live) {
        return String.format(STREAMING.getTemplate(), user.getNickName(), user.getProfileImage(),
                live.getTitle(), live.getId());
    }

    public static String getFriendRequestContent(User user) {
        return String.format(FRIEND_REQUEST.getTemplate(), user.getNickName(), user.getProfileImage());
    }

    public static String getLikesContent(User user, Video video) {
        return String.format(LIKES.getTemplate(), user.getNickName(), user.getProfileImage(),
                video.getTitle(), video.getId());
    }
}
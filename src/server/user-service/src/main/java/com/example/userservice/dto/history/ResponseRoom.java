package com.example.userservice.dto.history;

import com.example.userservice.entity.RoomViewer.RoomViewer;
import com.example.userservice.entity.User.Category;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ResponseRoom {
    private Long id;
    private String hostUuid;
    private String hostNickname;
    private String hostProfileImage;
    private String uuid; // 라이브, 실시간채팅 uuid
    private String title;
    private String thumbnail;
    private Category category;
    private LocalDateTime likedAt;
    private LocalDateTime lastViewedAt;

    public ResponseRoom (RoomViewer room) {
        this.id = room.getRoom().getId();
        this.hostUuid = room.getUser().getUuid();
        this.hostNickname = room.getUser().getNickName();
        this.hostProfileImage = room.getUser().getProfileImage();
        this.uuid = room.getRoom().getUuid();
        this.title = room.getRoom().getTitle();
        this.category = room.getRoom().getCategory();
        this.thumbnail = room.getRoom().getThumbnail();
        this.likedAt = room.getLikedAt();
        this.lastViewedAt = room.getLastViewedAt();
    }
}

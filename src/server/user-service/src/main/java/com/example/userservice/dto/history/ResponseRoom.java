package com.example.userservice.dto.history;

import com.example.userservice.entity.RoomViewer.RoomViewer;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ResponseRoom {
    private Long streamingId;
    private Long uuid;
    private String hostNickname;
    private String title;
    private int hits;
    private String thumbnail;
    private LocalDateTime likedAt;

    public ResponseRoom (RoomViewer room) {
        this.streamingId = room.getRoom().getId();
        this.uuid = room.getRoomUuid();
        this.hostNickname = room.getUser().getNickName();
        this.title = room.getRoom().getTitle();
        this.hits = room.getRoom().getLikeCnt();
        this.thumbnail = room.getRoom().getThumbnail();
        this.likedAt = room.getLikedAt();
    }
}

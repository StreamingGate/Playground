package com.example.roomservice.entity.RoomViewer;

import com.example.roomservice.entity.Room.Room;
import com.example.roomservice.entity.User.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import javax.persistence.*;
import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
@Entity(name = "room_viewer")
public class RoomViewer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;

    private Boolean liked;

    private Boolean disliked;

    private LocalDateTime likedAt;

    private LocalDateTime lastViewedAt;

    private Long roomUuid;

    private String userUuid;

    @ManyToOne
    @JoinColumn(name = "users_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "room_id")
    private Room room;


    @Builder
    public RoomViewer(Boolean liked,Long roomUuid,String userUuid) {
        this.liked = liked;
        this.disliked = liked? false : true;
        this.roomUuid = roomUuid;
        this.userUuid = userUuid;
    }

    public static RoomViewer join(Long roomUuid,String userUuid,Boolean liked) {
        return RoomViewer.builder()
                .roomUuid(roomUuid)
                .userUuid(userUuid)
                .liked(liked)
                .build();
    }

}

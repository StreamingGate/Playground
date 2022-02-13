package com.example.roomservice.entity.RoomViewer;

import com.example.roomservice.entity.Room.Room;
import com.example.roomservice.entity.User.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
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

    @ColumnDefault(value = "CURRENT_TIMESTAMP")
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
    public RoomViewer(Boolean liked,Boolean disliked ,Long roomUuid,String userUuid,LocalDateTime lastViewedAt) {
        this.liked = liked;
        this.disliked = disliked;
        this.roomUuid = roomUuid;
        this.userUuid = userUuid;
        this.lastViewedAt = lastViewedAt;
    }

    public static RoomViewer join(Long roomUuid,String userUuid,Boolean liked,Boolean disliked) {
        return RoomViewer.builder()
                .roomUuid(roomUuid)
                .userUuid(userUuid)
                .liked(liked)
                .disliked(disliked)
                .lastViewedAt(LocalDateTime.now())
                .build();
    }
}

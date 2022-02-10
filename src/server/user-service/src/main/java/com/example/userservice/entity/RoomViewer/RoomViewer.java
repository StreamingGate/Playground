package com.example.userservice.entity.RoomViewer;

import com.example.userservice.entity.Room.Room;
import com.example.userservice.entity.User.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.*;
import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
@Entity
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
    public RoomViewer(Boolean liked,Long roomUuid,String userUuid) {
        this.liked = liked;
        this.disliked = liked? false : true;
        this.roomUuid = roomUuid;
        this.userUuid = userUuid;
    }

}

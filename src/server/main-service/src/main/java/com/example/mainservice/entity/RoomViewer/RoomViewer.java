package com.example.mainservice.entity.RoomViewer;

import com.example.mainservice.entity.Room.Room;
import com.example.mainservice.entity.User.User;
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
    private Long id;

    private boolean liked = false;

    private boolean disliked = false;

    private LocalDateTime likedAt;

    @ColumnDefault(value = "CURRENT_TIMESTAMP")
    private LocalDateTime lastViewedAt;



    @ManyToOne
    @JoinColumn(name = "users_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "room_id")
    private Room room;

    public RoomViewer(User user, Room room) {
        this.user = user;
        this.room = room;
        user.getRoomViewers().add(this);
        room.getRoomViewers().add(this);
    }

    /* 좋아요 실행 또는 취소 (좋아요 누를 시 싫어요 효과는 취소 된다.) */
    public void setLiked(boolean liked) {
        /* 좋아요 값 변경시 likedAt, likeCnt이 변경된다 */
        if (this.liked == false && liked == true) {
            room.addLikeCnt(1);
            this.likedAt = LocalDateTime.now();
            this.disliked = false;
        } else if(this.liked == true && liked == false){
            room.addLikeCnt(-1);
            this.likedAt = null;
        }
        this.liked = liked;
    }

    /* 싫어요 실행 또는 취소 (싫어요 누를 시 좋아요 효과는 취소 된다.) */
    public void setDisliked(boolean disliked) {
        /* 반영하려는 값이 현재 값과 다를때만 값 적용한다. */
        if (this.disliked == false && disliked == true) {
            if(this.liked == true){
                setLiked(false);
            }
        }
        this.disliked = disliked;
    }
}

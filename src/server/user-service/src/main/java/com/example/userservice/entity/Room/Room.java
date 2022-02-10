package com.example.userservice.entity.Room;

import com.example.userservice.entity.RoomViewer.RoomViewer;
import com.example.userservice.entity.User.Category;
import com.example.userservice.entity.User.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@NoArgsConstructor
@Getter
@Entity(name = "room")
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String uuid;

    @Column(length = 100)
    private String title;

    @Column(length = 5000)
    private String content;

    private String hostUuid;

    @Column(columnDefinition = "MEDIUMBLOB")
    private String thumbnail;

    private int likeCnt;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private Category category;

    @Column(nullable = false, updatable = false, insertable = false)
    @ColumnDefault(value = "CURRENT_TIMESTAMP")
    private LocalDateTime createdAt;

    private short reportCnt;

    @ManyToOne
    @JoinColumn(name = "users_id")
    private User user;

    @OneToMany(mappedBy = "room")
    private List<RoomViewer> roomViewer;

    @Builder
    public Room(String uuid,String title,String content,String hostUuid,String thumbnail,Category category) {
        this.uuid = uuid;
        this.title = title;
        this.content = content;
        this.hostUuid = hostUuid;
        this.thumbnail = thumbnail;
        this.category = category;
    }

}

package com.example.mainservice.entity.FriendWait;

import com.example.mainservice.entity.User.UserEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import javax.persistence.*;

@NoArgsConstructor
@Getter
@Entity
public class FriendWait {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 8)
    private String senderNickname;

    @Column(length = 36)
    private String senderUuid;

    @Column(columnDefinition = "TEXT")
    private String senderProfileImage;

    @ManyToOne
    @JoinColumn(name = "users_id")
    private UserEntity userEntity; //friends들이 나를 참조

    public static FriendWait create(UserEntity user, UserEntity target){
        return FriendWait.builder()
                .senderUuid(user.getUuid())
                .senderNickname(user.getNickName())
                .senderProfileImage(user.getProfileImage())
                .userEntity(target)
                .build();
    }
    @Builder
    public FriendWait(String senderNickname, String senderUuid, String senderProfileImage, UserEntity userEntity){
        this.senderNickname = senderNickname;
        this.senderUuid = senderUuid;
        this.senderProfileImage = senderProfileImage;
        this.userEntity = userEntity;
    }
}

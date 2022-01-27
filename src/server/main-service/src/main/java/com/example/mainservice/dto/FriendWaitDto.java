package com.example.mainservice.dto;

import com.example.mainservice.entity.FriendWait.FriendWait;
import com.example.mainservice.entity.User.UserEntity;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@Setter
@Getter
public class FriendWaitDto {

    private String uuid;
    private String nickname;
    private String profileImage;

    public FriendWaitDto(FriendWait friendWait) {
        this.uuid = friendWait.getSenderUuid();
        this.nickname = friendWait.getSenderNickname();
        this.profileImage = friendWait.getSenderProfileImage();
    }
}

package com.example.mainservice.dto;

import com.example.mainservice.entity.FriendWait.FriendWait;
import lombok.Data;

@Data
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

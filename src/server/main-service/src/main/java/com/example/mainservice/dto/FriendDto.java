package com.example.mainservice.dto;

import com.example.mainservice.entity.User.User;
import lombok.AllArgsConstructor;
import lombok.Data;

@AllArgsConstructor
@Data
public class FriendDto {

    private String uuid;
    private String nickname;
    private String profileImage;

    public static FriendDto from(User user) {
        return new FriendDto(user.getUuid(), user.getNickName(), user.getProfileImage());
    }
}

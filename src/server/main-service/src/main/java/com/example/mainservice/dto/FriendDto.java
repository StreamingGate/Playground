package com.example.mainservice.dto;

import com.example.mainservice.entity.User.UserEntity;
import lombok.*;

@AllArgsConstructor
@Data
public class FriendDto {

    private String nickname;
    private String profileImage;

    public static FriendDto from(UserEntity userEntity) {
        return new FriendDto(userEntity.getNickName(), userEntity.getProfileImage());
    }
}

package com.example.mainservice.dto;

import com.example.mainservice.entity.User.UserEntity;
import lombok.*;

@AllArgsConstructor
@Data
public class FriendDto {

    private String uuid;
    private String nickname;
    private String profileImage;

    public static FriendDto from(UserEntity userEntity) {
        return new FriendDto(userEntity.getUuid(), userEntity.getNickName(), userEntity.getProfileImage());
    }
}

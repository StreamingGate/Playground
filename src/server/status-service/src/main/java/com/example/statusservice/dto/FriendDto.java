package com.example.statusservice.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class FriendDto {
    private String uuid;            // user uuid
    private String nickname;
    private String profileImage;
}

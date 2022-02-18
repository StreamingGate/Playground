package com.example.userservice.dto.user;

import lombok.Data;

@Data
public class ResponseUser {
    private String email;
    private String uuid;
    private String name;
    private String nickName;
    private String profileImage;
    private Integer friendCnt;
    private Integer uploadCnt;
}

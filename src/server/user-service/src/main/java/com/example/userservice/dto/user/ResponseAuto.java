package com.example.userservice.dto.user;

import lombok.Data;

@Data
public class ResponseAuto {
    private String email;
    private String name;
    private String nickName;
    private String refreshToken;
    private String profileImage;
}

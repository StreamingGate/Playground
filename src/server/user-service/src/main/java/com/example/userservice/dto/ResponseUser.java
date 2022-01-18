package com.example.userservice.dto;

import lombok.Data;

@Data
public class ResponseUser {
    private String email;
    private String name;
    private String nickName;
    private String profileImage;
}

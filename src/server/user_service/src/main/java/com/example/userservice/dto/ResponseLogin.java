package com.example.userservice.dto;

import lombok.Data;

@Data
public class ResponseLogin {
    private String email;
    private String name;
    private String nickName;
}

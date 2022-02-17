package com.example.userservice.dto.user;

import lombok.Data;

@Data
public class RequestAuto {
    private String accessToken;
    private String email;
    private String uuid;
}

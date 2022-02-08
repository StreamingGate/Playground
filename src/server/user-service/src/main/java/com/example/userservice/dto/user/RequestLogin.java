package com.example.userservice.dto.user;

import lombok.Data;

import javax.validation.constraints.Email;

@Data
public class RequestLogin {
    @Email
    private String email;
    private String password;
}

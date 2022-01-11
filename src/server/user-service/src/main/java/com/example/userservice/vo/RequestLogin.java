package com.example.userservice.vo;

import lombok.Data;

import javax.validation.constraints.Email;

@Data
public class RequestLogin {
    @Email
    private String email;
    private String password;
}

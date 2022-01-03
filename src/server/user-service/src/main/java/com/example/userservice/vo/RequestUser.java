package com.example.userservice.vo;

import lombok.Data;
import javax.validation.constraints.Email;

@Data
public class RequestUser {
    @Email
    private String email;

    private String name;

    private String nickName;

    private String password;

}

package com.example.userservice.dto;

import lombok.Data;
import java.time.LocalDate;

//@Data
public class UserDto {
    private String email;
    private String uuid;
    private String password;
    private String encryptedPwd;
    private String name;
    private String nickName;
    private String profileImage;
    private LocalDate modifiedAt;
    private  LocalDate deletedAt;
}

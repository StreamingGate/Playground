package com.example.userservice.dto.user;

import lombok.Data;

@Data
public class RegisterUser {
    /* TODO: test이후 지우기 */
//    @Email
    private String email;
//    @Size(max = 30)
    private String name;
//    @Size(max = 8)
    private String nickName;
//    @Size(min = 6,max = 16 )
    private String password;
    private String profileImage;
}

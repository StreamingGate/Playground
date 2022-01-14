package com.example.userservice.service;

import com.example.userservice.dto.UserDto;
import org.springframework.security.core.userdetails.UserDetailsService;

public interface UserService extends UserDetailsService {
    UserDto createUser(UserDto userDto);
    UserDto updateUser(String userId,UserDto requestDto);
    UserDto getUserByEmail(String email);
    void deleteUser(String userId);
//    String checkEmail(String email);
}

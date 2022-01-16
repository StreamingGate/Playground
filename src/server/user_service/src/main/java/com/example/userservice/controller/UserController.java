package com.example.userservice.controller;

import com.example.userservice.dto.UserDto;
import com.example.userservice.service.UserService;
import com.example.userservice.dto.RegisterUser;
import com.example.userservice.dto.ResponseUser;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/")
public class UserController {
    private final UserService userService;
    private final ModelMapper mapper;

    @Autowired
    public UserController(UserService userService, ModelMapper mapper){
        this.userService = userService;
        this.mapper = mapper;
    }

    /* 회원가입 */
    @PostMapping("/users")
    public ResponseEntity<ResponseUser> createUser(@RequestBody RegisterUser registerUser) throws Exception {
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        registerUser = userService.createUser(registerUser);
        ResponseUser responseUser = mapper.map(registerUser,ResponseUser.class);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseUser);
    }

    /* 정보수정 */
    @PutMapping("/users/{uuid}")
    public ResponseEntity<ResponseUser> updateUser(@PathVariable("uuid") String uuid,
                                                   @RequestBody RegisterUser registerUser) throws Exception{
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        registerUser = userService.updateUser(uuid,registerUser);
        ResponseUser responseUser = mapper.map(registerUser,ResponseUser.class);
        return ResponseEntity.status(HttpStatus.OK).body(responseUser);
    }

    /* 회원 탈퇴 */
    @DeleteMapping("/users/{uuid}")
    public ResponseEntity<String> deleteUser(@PathVariable("uuid") String uuid) {
        userService.deleteUser(uuid);
        return ResponseEntity.status(HttpStatus.OK).body(uuid);
    }

    /* TODO : 회원가입 이메일 인증 */
//    @PostMapping("/users/mail")
//    public ResponseEntity<String> checkUserMail(@RequestBody String email) {
//
//        return ResponseEntity.status(HttpStatus.OK).body(email);
//    }

}

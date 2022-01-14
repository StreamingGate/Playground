package com.example.userservice.controller;

import com.example.userservice.dto.UserDto;
import com.example.userservice.service.UserService;
import com.example.userservice.vo.RequestUser;
import com.example.userservice.vo.ResponseUser;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletResponse;

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
    public ResponseEntity<ResponseUser> createUser(@RequestBody RequestUser requestUser,
                                                   HttpServletResponse response) throws Exception {
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        UserDto userDto = mapper.map(requestUser, UserDto.class);
        userDto = userService.createUser(userDto);
        ResponseUser responseUser = mapper.map(userDto,ResponseUser.class);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseUser);
    }
    /* 정보수정 */
    @PutMapping("/users/{userId}")
    public ResponseEntity<ResponseUser> updateUser(@PathVariable("userId") String userId,
                                                   @RequestBody RequestUser requestUser) throws Exception{
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        UserDto requestDto = mapper.map(requestUser,UserDto.class);
        requestDto = userService.updateUser(userId,requestDto);
        ResponseUser responseUser = mapper.map(requestDto,ResponseUser.class);
        return ResponseEntity.status(HttpStatus.OK).body(responseUser);
    }

    /* 회원 탈퇴 */
    @DeleteMapping("/users/{userId}")
    public ResponseEntity<String> deleteUser(@PathVariable("userId") String userId) {
        userService.deleteUser(userId);
        return ResponseEntity.status(HttpStatus.OK).body(userId);
    }

    /* 회원가입 이메일 인증 */
    @PostMapping("/users/mail")
    public ResponseEntity<String> checkUserMail(@RequestBody String email) {

        return ResponseEntity.status(HttpStatus.OK).body(email);
    }

}

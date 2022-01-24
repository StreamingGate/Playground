package com.example.userservice.controller;

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
    public ResponseEntity<ResponseUser> register(@RequestBody RegisterUser registerUser) throws Exception {
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        registerUser = userService.register(registerUser);
        ResponseUser responseUser = mapper.map(registerUser,ResponseUser.class);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseUser);
    }

    /* 정보수정 */
    @PutMapping("/users/{uuid}")
    public ResponseEntity<ResponseUser> update(@PathVariable("uuid") String uuid,
                                                   @RequestBody RegisterUser registerUser) throws Exception{
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        registerUser = userService.update(uuid,registerUser);
        ResponseUser responseUser = mapper.map(registerUser,ResponseUser.class);
        return ResponseEntity.status(HttpStatus.OK).body(responseUser);
    }

    /* 회원 탈퇴 */
    @DeleteMapping("/users/{uuid}")
    public ResponseEntity<String> delete(@PathVariable("uuid") String uuid) {
        userService.delete(uuid);
        return ResponseEntity.status(HttpStatus.OK).body(uuid);
    }
    /* 이메일 인증코드 전송 */
    /* TODO : param -> body */
    @PostMapping("/users/mail")
    public ResponseEntity<String> checkMail(@RequestParam(value = "email") String email) throws Exception{
        String res = userService.checkEmail(email);
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }
    /* 인증코드 확인 */
    @GetMapping("/users/mail")
    public ResponseEntity<String> checkCode(@RequestParam(value = "code") String code) throws Exception{
        String res = userService.checkCode(code);
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    /* 비밀번호 찾기 인증코드 전송 */
    @PostMapping("/password")
    public ResponseEntity<?> findPassword(@RequestParam(value = "email") String email,
                                               @RequestParam(value = "name") String name) {
        String res = userService.checkUser(name,email);
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    /* 닉네임 중복체크 */
    @GetMapping("/nickname")
    public ResponseEntity<Boolean> checkNickName(@RequestParam(value = "nickname") String nickName) throws Exception{
        boolean res = userService.checkNickName(nickName);
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    /*  */
}

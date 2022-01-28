package com.example.userservice.controller;

import com.example.userservice.dto.*;
import com.example.userservice.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

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
    @PutMapping("/{uuid}")
    public ResponseEntity<ResponseUser> update(@PathVariable("uuid") String uuid,
                                               @RequestBody RequestMyinfo requestMyinfo) throws Exception {
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        requestMyinfo = userService.update(uuid,requestMyinfo);
        ResponseUser responseUser = mapper.map(requestMyinfo,ResponseUser.class);
        return ResponseEntity.status(HttpStatus.OK).body(responseUser);
    }

    /* 비밀번호 수정 */
    @PutMapping("/password/{uuid}")
    public ResponseEntity<PwdDto> updatePwd(@PathVariable("uuid") String uuid,
                                                  @RequestBody PwdDto pwdDto) throws Exception {
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        PwdDto res = userService.updatePwd(uuid, pwdDto);
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    /* 회원 탈퇴 */
    @DeleteMapping("/{uuid}")
    public ResponseEntity<Map<String,String>> delete(@PathVariable("uuid") String uuid) throws Exception {
        userService.delete(uuid);
        Map<String,String> res = new HashMap<>();
        res.put("uuid",uuid);
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    /* 이메일 인증코드 전송 */
    @PostMapping("/email")
    public ResponseEntity<EmailDto> checkMail(@RequestBody EmailDto email) throws Exception {
        EmailDto res = userService.checkEmail(email);
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }
    /* 인증코드 확인 */
    @GetMapping("/email")
    public ResponseEntity<Map<String,String>> checkCode(@RequestParam(value = "code") String code) throws Exception {
        String resultEmail = userService.checkCode(code);
        Map<String,String> res = new HashMap<>();
        res.put("email",resultEmail);
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    /* 비밀번호 찾기 인증코드 전송 */
    @PostMapping("/password")
    public ResponseEntity<Map<String,String>> findPassword(@RequestBody PwdDto pwdDto) {
        PwdDto resultDto = userService.checkUser(pwdDto);
        Map<String,String> res = new HashMap<>();
        res.put("email",resultDto.getEmail());
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    /* 닉네임 중복체크 */
    @GetMapping("/nickname")
    public ResponseEntity<Map<String,String>> checkNickName(@RequestParam(value = "nickname") String nickName) throws Exception {
        String resultNickname = userService.checkNickName(nickName);
        Map<String,String> res = new HashMap<>();
        res.put("nickName",resultNickname);
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }
}

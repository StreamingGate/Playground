package com.example.userservice.controller;

import com.example.userservice.dto.history.ResponseHistory;
import com.example.userservice.dto.history.ResponseVideo;
import com.example.userservice.dto.user.*;
import com.example.userservice.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
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
        ResponseUser responseUser = userService.update(uuid,requestMyinfo);
        return ResponseEntity.status(HttpStatus.OK).body(responseUser);
    }

    /* 비밀번호 수정 */
    @PutMapping("/password/{uuid}")
    public ResponseEntity<Pwd> updatePwd(@PathVariable("uuid") String uuid,
                                         @RequestBody Pwd pwd) throws Exception {
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        Pwd res = userService.updatePwd(uuid, pwd);
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
    public ResponseEntity<String> checkMail(@RequestBody String email) throws Exception {
        String res = userService.checkEmail(email);
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
    public ResponseEntity<Map<String,String>> findPassword(@RequestBody Pwd pwd) {
        Pwd resultDto = userService.checkUser(pwd);
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

    /* 시청한 동영상 목록 조회 */
    @GetMapping("/watch/{uuid}")
    public ResponseEntity<ResponseHistory> watchedHistory(@PathVariable("uuid") String uuid,
                                                          @RequestParam("last-video") Long lastVideoId,
                                                          @RequestParam("last-live") Long lastLiveId,
                                                          @RequestParam("size") int size) throws Exception {

        return ResponseEntity.status(HttpStatus.OK).body(userService.watchedHistory(uuid,lastVideoId,lastLiveId,size));
    }

    /* 좋아요 누른 동영상 조회 */
    @GetMapping("/liked/{uuid}")
    public ResponseEntity<ResponseHistory> likedHistory(@PathVariable("uuid") String uuid,
                                          @RequestParam("last-video") Long lastVideoId,
                                          @RequestParam("last-live") Long lastLiveId,
                                          @RequestParam("size") int size) throws Exception {

        return ResponseEntity.status(HttpStatus.OK).body(userService.likedHistory(uuid, lastVideoId, lastLiveId, size));
    }

    /* 내가 업로드한 영상 조회 */
    @GetMapping("/upload/{uuid}")
    public ResponseEntity<List<ResponseVideo>> uploadedHistory(@PathVariable("uuid") String uuid,
                                                               @RequestParam("last-video") Long lastVideoId,
                                                               @RequestParam("size") int size) throws Exception {

        return ResponseEntity.status(HttpStatus.OK).body(userService.uploadedHistory(uuid, lastVideoId, size));
    }

    /* refresh Token 발행 */
    @PostMapping("/refresh")
    public ResponseEntity<Map<String,String>> refreshToken(@RequestHeader("token") String token,
                                                      @RequestHeader("refreshToken") String refreshToken) throws Exception {
        Map<String,String> res = new HashMap<>();
        res.put("token",userService.refreshToken(token, refreshToken));
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }
}

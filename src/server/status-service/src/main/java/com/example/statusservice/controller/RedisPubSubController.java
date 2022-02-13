package com.example.statusservice.controller;

import com.example.statusservice.dto.UserDto;
import com.example.statusservice.redis.RedisUserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;

/**
 * <h1>RedisPubSubController</h1>
 * broker 역할을 합니다. (특정 topic에 publish된 메시지들을 subscriber에게 전송)
 */
@Slf4j
@RequiredArgsConstructor
@Controller
public class RedisPubSubController {

    private final RedisUserService redisUserService;

//    /* 로그인 시 친구에게 publish */
//    @MessageMapping("/status/login/{uuid}")
//    public void loginMessage(@DestinationVariable String uuid) throws Exception{
//        // create payload
//        log.info("==MessageMapping: loginMessage from:"+uuid);
//        redisUserService.statusPublish(uuid, Boolean.TRUE);
//    }
//
//    /* 로그아웃 시 친구에게 publish */
//    @MessageMapping("/status/logout/{uuid}")
//    public void logoutMessage(@DestinationVariable String uuid) throws Exception{
//        // create payload
//        log.info("==MessageMapping: logoutMessage from:"+uuid);
//        redisUserService.statusPublish(uuid, Boolean.FALSE);
//    }

    /* 현재 시청하는 영상 또는 라이브 공유 */
    @MessageMapping("/watch/{uuid}")
    public void watchNowOrExitMessage(@DestinationVariable String uuid,
                                      @RequestBody UserDto userDto) throws Exception {
        log.info("==MessageMapping: watchNowMessage from: "+uuid);
        log.info("target video or live: "+userDto.getTitle());
        redisUserService.publishWatching(uuid, userDto);
    }
}

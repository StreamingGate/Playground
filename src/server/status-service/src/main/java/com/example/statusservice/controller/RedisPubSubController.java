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

    /* 현재 시청하는 영상 또는 라이브 공유 */
    @MessageMapping("/watch/{uuid}")
    public void watchNowOrExitMessage(@DestinationVariable String uuid,
                                      @RequestBody UserDto userDto) throws Exception {
        log.info("==MessageMapping: watchNowMessage from: "+uuid);
        log.info("target video or live: "+userDto.getTitle());
        redisUserService.publishWatching(uuid, userDto);
    }
}

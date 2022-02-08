package com.example.statusservice.controller;

import com.example.statusservice.dto.login.LoginDto;
import com.example.statusservice.entity.User.User;
import com.example.statusservice.exception.CustomStatusException;
import com.example.statusservice.exception.ErrorResponse;
import com.example.statusservice.redis.RedisUserService;
import com.example.statusservice.utils.ClientMessaging;
import com.example.statusservice.utils.RedisMessaging;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

import static com.example.statusservice.exception.ErrorCode.C001;

/**
 * <h1>ChatController</h1>
 * broker 역할을 합니다.(특정 topic에 publish된 메시지들을 subscriber에게 전송)
 */
@Slf4j
@RequiredArgsConstructor
@Controller
public class RedisPubSubController {    /* TODO: Scheduling 적용 */

//    private static final String CHAT_DESTINATION="/topic/chat/room/";
//    private static final String USER_CNT_DESTINATION="/topic/user-cnt/room/";
//    private static final String ERROR_DESTINATION="/queue/errors";
    private final RedisUserService redisUserService;

    /* 로그인시 친구에게 produce */
    @MessageMapping("/status/login/{uuid}")
    public void loginMessage(@DestinationVariable String uuid) throws Exception{
        // create payload
        User user = redisUserService.findById(uuid);
        List<User> friends = user.getFriends();
        for(User friend: friends) {
            RedisMessaging.publish(redisUserService.getTopic(friend.getUuid()), 1);
        }
    }

    @MessageMapping("/status/logout/{uuid}")
    public void logoutMessag(@DestinationVariable String uuid) throws Exception{
        // create payload
        User user = redisUserService.findById(uuid);
        List<User> friends = user.getFriends();
        for(User friend: friends) {
            RedisMessaging.publish(redisUserService.getTopic(friend.getUuid()), 0);
        }
    }
}

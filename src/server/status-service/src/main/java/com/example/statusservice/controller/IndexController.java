package com.example.statusservice.controller;


import com.example.statusservice.dto.UserDto;
import com.example.statusservice.redis.RedisUserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Controller
public class IndexController {

    private final RedisUserService redisUserService;

    @GetMapping("/home")
    public String home(){
        return "home";
    }

    @ResponseBody
    @GetMapping("/init-redis")
    public String initRedis(){
        redisUserService.initRedis();
        redisUserService.addTopics();
        return "";
    }

    @ResponseBody
    @GetMapping("/list")
    public List<UserDto> getFriendsStatus(@RequestParam("uuid")String uuid){
        log.info("list uuid:"+uuid);
        return redisUserService.findAll(uuid);
    }
}

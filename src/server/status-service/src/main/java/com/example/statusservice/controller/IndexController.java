package com.example.statusservice.controller;


import com.example.statusservice.redis.RedisUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
    public void initRedis(){
        redisUserService.initRedis();
        redisUserService.addTopics();
    }
}

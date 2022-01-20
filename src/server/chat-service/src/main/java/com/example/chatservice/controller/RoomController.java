package com.example.chatservice.controller;

import com.example.chatservice.dto.ChatDto;
import com.example.chatservice.dto.RoomDto;
import com.example.chatservice.redis.RedisRoomRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/chat")
public class RoomController {

    private final RedisRoomRepository redisRoomRepository;

    @GetMapping("/room/{roomId}")
    @ResponseBody
    public RoomDto roomInfo(@PathVariable("roomId") String id) {
        RoomDto res = redisRoomRepository.findById(id);
        log.info("recorded chat end.......");
        return res;
    }

    @PostMapping("/room")
    @ResponseBody
    public RoomDto createRoom(@RequestParam String name) {
        log.info("채팅방 생성: name="+name);
        RoomDto res = redisRoomRepository.create(name);
        log.info("res: id="+res.getId());
        return res;
    }
}

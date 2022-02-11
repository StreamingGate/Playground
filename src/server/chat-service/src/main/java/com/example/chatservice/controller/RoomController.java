package com.example.chatservice.controller;

import com.example.chatservice.model.room.Room;
import com.example.chatservice.redis.RedisRoomService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
@RequestMapping("/chat")
public class RoomController {

    private final RedisRoomService redisRoomRepository;

    @GetMapping("/room/{roomId}")
    @ResponseBody
    public Room roomInfo(@PathVariable("roomId") String id) {
        Room res = redisRoomRepository.findById(id);
        return res;
    }

    @PostMapping("/room")
    @ResponseBody
    public Room createRoom(@RequestParam String name) {
        Room res = redisRoomRepository.create(name);
        return res;
    }
}

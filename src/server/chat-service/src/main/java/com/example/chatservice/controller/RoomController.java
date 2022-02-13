package com.example.chatservice.controller;

import com.example.chatservice.dto.room.Room;
import com.example.chatservice.dto.room.RoomCreateDto;
import com.example.chatservice.redis.RedisRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/chat")
public class RoomController {

    private final RedisRoomService redisRoomRepository;

    @GetMapping("/room/{roomId}")
    public Room roomInfo(@PathVariable("roomId") String id) {
        Room res = redisRoomRepository.findById(id);
        return res;
    }

    @PostMapping("/room")
    public Room createRoom(@RequestBody RoomCreateDto roomCreateDto) {
        Room res = redisRoomRepository.create(roomCreateDto.getUuid(), roomCreateDto.getHostUuid());
        return res;
    }
}

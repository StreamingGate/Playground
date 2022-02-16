package com.example.chatservice.controller;

import com.example.chatservice.dto.room.Room;
import com.example.chatservice.redis.RedisRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/chat")
public class RoomController {

    private final static String UUID_KEY = "uuid";
    private final RedisRoomService redisRoomRepository;

    @GetMapping("/room/{roomUuid}")
    public Room roomInfo(@PathVariable("roomUuid") String uuid) {
        return redisRoomRepository.findById(uuid);
    }

    @PostMapping("/room")
    public Room createRoom(@RequestBody Map<String, String> roomCreateDto) {
        String uuid = roomCreateDto.get(UUID_KEY);
        return redisRoomRepository.create(uuid);
    }

    @DeleteMapping("/room")
    public String deleteRoom(@RequestBody Map<String, String> roomCreateDto){
        String uuid = roomCreateDto.get(UUID_KEY);
        return redisRoomRepository.removeRoom(uuid);
    }
}

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
    public Room roomInfo(@PathVariable("roomId") String uuid) {
        return redisRoomRepository.findById(uuid);
    }

    @PostMapping("/room")
    public Room createRoom(@RequestBody RoomCreateDto roomCreateDto) {
        return redisRoomRepository.create(roomCreateDto.getUuid(), roomCreateDto.getHostUuid());
    }

    @DeleteMapping("/room")
    public String deleteRoom(@RequestParam("uuid") String uuid){
        return redisRoomRepository.removeRoom(uuid);
    }
}

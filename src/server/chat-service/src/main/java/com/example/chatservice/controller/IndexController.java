package com.example.chatservice.controller;

import com.example.chatservice.dto.RoomDto;
import com.example.chatservice.model.room.Room;
import com.example.chatservice.redis.RedisRoomRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RequestMapping("/chat")
@Controller
public class IndexController {
    
    private final RedisRoomRepository redisRoomRepository;

    @GetMapping("/room")
    public String rooms(Model model) {
        List<Room> rooms = redisRoomRepository.findAll();
        log.info("room cnt: "+ rooms.size());
        model.addAttribute("rooms", rooms);
        return "/room";
    }
    
    @GetMapping("/room/enter/{roomId}")
    public String roomDetail(Model model, @PathVariable String roomId) {
        log.info("enter room....");
        model.addAttribute("roomId", roomId);
        return "/roomdetail";
    }
}

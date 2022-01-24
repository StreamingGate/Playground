package com.example.chatservice.controller;

import java.util.List;
import com.example.chatservice.model.room.Room;
import com.example.chatservice.redis.RedisRoomService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@RequestMapping("/chat")
@Controller
public class IndexController {
    
    private final RedisRoomService redisRoomRepository;

    @GetMapping("/room")
    public String rooms(Model model) {
        List<Room> rooms = redisRoomRepository.findAll();
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

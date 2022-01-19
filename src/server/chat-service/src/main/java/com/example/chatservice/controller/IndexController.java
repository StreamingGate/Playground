package com.example.chatservice.controller;

import com.example.chatservice.service.RoomService;

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
    
    private final RoomService roomService;

    @GetMapping("/room")
    public String rooms(Model model) {
        model.addAttribute("rooms", roomService.findAll());
        return "/room";
    }
    
    @GetMapping("/room/enter/{roomId}")
    public String roomDetail(Model model, @PathVariable String roomId) {
        log.info("enter room....");
        model.addAttribute("roomId", roomId);
        return "/roomdetail";
    }
}

package com.example.chatservice.controller;

import com.example.chatservice.dto.ChatRoom;
import com.example.chatservice.service.ChatService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/chat")
public class ChatRoomController {

    private final ChatService chatService;

    @GetMapping("/room")
    public String rooms(Model model) {
        model.addAttribute("rooms", chatService.findAllRoom());
        return "/room";
    }

    @PostMapping("/room")
    @ResponseBody
    public ChatRoom createRoom(@RequestParam String name) {
        log.info("채팅방 생성: name="+name);
        
        ChatRoom res = chatService.createRoom(name);
        
        log.info("res: id="+res.getRoomId());
        return res;
    }

    @GetMapping("/room/enter/{roomId}")
    public String roomDetail(Model model, @PathVariable String roomId) {
        log.info("enter room....");
        model.addAttribute("roomId", roomId);
        return "/roomdetail";
    }

    @GetMapping("/room/{roomId}")
    @ResponseBody
    public ChatRoom roomInfo(@PathVariable String roomId) {
        ChatRoom res = chatService.findRoomById(roomId);
        log.info(res.getName()+" " + res.getRoomId());
        return res;
    }
}

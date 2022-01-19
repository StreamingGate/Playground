package com.example.chatservice.controller;

import com.example.chatservice.dto.ChatDto;
import com.example.chatservice.dto.RoomDto;
import com.example.chatservice.service.RoomService;

import org.springframework.stereotype.Controller;
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
public class RoomController {

    private final RoomService roomService;

    @GetMapping("/room/{roomId}")
    @ResponseBody
    public RoomDto roomInfo(@PathVariable("roomId") String id) {
        RoomDto res = roomService.findById(id);
        log.info(res.getName()+" " + res.getId());
        log.info("recorded chat start.......");
        if(res.getChats() != null) {
            for(ChatDto dto: res.getChats()) {
                log.info(dto.getNickname() + " " +dto.getMessage());
            }
        }
        log.info("recorded chat end.......");
        return res;
    }

    @PostMapping("/room")
    @ResponseBody
    public RoomDto createRoom(@RequestParam String name) {
        log.info("채팅방 생성: name="+name);
        RoomDto res = roomService.create(name);
        log.info("res: id="+res.getId());
        
        return res;
    }
}

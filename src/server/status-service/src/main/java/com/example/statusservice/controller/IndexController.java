package com.example.statusservice.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class IndexController {
  
    @GetMapping("/home")
    public String home(){
        return "home";
    }

    @GetMapping("/video-or-room")
    public String videoOrRoom(){
        return "videoOrRoom";
    }
}

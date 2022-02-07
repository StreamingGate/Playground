package com.example.roomservice.controller;

import com.example.roomservice.dto.RequestDto;
import com.example.roomservice.dto.ResponseDto;
import com.example.roomservice.service.RoomService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
public class RoomController {
    private final RoomService roomService;

    @GetMapping("/room")
    public ResponseEntity<ResponseDto> join(@RequestParam (value = "roomId") Long roomId,
                                            @RequestParam (value = "uuid") String uuid) throws Exception {
        ResponseDto responseDto = roomService.join(roomId,uuid);
        return ResponseEntity.status(HttpStatus.OK).body(responseDto);
    }

    @PostMapping("/room")
    public ResponseEntity<Map<String,String>> create(@RequestBody RequestDto requestDto) throws Exception {
        ResponseDto responseDto = roomService.create(requestDto);
        Map<String,String> res = new HashMap<>();
        res.put("roomId",responseDto.getRoomId().toString());
        res.put("uuid",requestDto.getUuid());
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }
}

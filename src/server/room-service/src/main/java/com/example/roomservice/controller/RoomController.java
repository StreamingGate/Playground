package com.example.roomservice.controller;

import com.example.roomservice.dto.RequestDto;
import com.example.roomservice.dto.RequestExitDto;
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
    /* 방 참가 */
    @GetMapping("/room")
    public ResponseEntity<ResponseDto> join(@RequestParam (value = "roomId") Long roomId,
                                            @RequestParam (value = "uuid") String uuid) throws Exception {
        ResponseDto responseDto = roomService.join(roomId,uuid);
        return ResponseEntity.status(HttpStatus.OK).body(responseDto);
    }
    /* 방 생성 */
    @PostMapping("/room")
    public ResponseEntity<Map<String,String>> create(@RequestBody RequestDto requestDto) throws Exception {
        ResponseDto responseDto = roomService.create(requestDto);
        Map<String,String> res = new HashMap<>();
        res.put("roomId",responseDto.getRoomId().toString());
        res.put("uuid",requestDto.getUuid());
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }
    /* 방 생성 가능한 uuid인지 체크 */
    @GetMapping("/check")
    public ResponseEntity<String> check(@RequestParam (value = "uuid") String uuid) throws Exception {
        return ResponseEntity.status(HttpStatus.OK).body(roomService.check(uuid));
    }

    /* 방 종료 */
//    @DeleteMapping("/room")
//    public ResponseEntity<Map<String,String>> exit(@RequestBody RequestExitDto requestExitDto) throws Exception {
//
//    }

}

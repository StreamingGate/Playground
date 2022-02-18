package com.example.mainservice.controller;

import com.example.mainservice.dto.FriendDto;
import com.example.mainservice.dto.FriendWaitDto;
import com.example.mainservice.service.FriendService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RequestMapping("/friends")
@RestController
public class FriendController {

    private static final String TARGET_MAP_KEY = "target";
    private static final String SENDER_MAP_KEY = "sender";
    private static final String RESPONSE_MAP_KEY = "result";
    private final FriendService friendService;

    @GetMapping("/{uuid}")
    public ResponseEntity<Map<String, List<FriendDto>>> getFriendList(@PathVariable("uuid") String uuid) throws Exception {
        return ResponseEntity.ok(Map.of(RESPONSE_MAP_KEY, friendService.getFriendList(uuid)));
    }

    @PostMapping("/{uuid}")
    public ResponseEntity<Map<String, String>> requestFriend(@PathVariable("uuid") String uuid,
                                                             @RequestBody Map<String, String> map) throws Exception {
        log.info("target: " + map.get("target"));
        String result = friendService.requestFriend(uuid, map.get(TARGET_MAP_KEY));
        return ResponseEntity.ok(Map.of(RESPONSE_MAP_KEY, result));
    }

    @DeleteMapping("/{uuid}")
    public ResponseEntity<Map<String, String>> deleteFriend(@PathVariable("uuid") String uuid,
                                                            @RequestBody Map<String, String> map) throws Exception {
        String result = friendService.deleteFriend(uuid, map.get(TARGET_MAP_KEY));
        return ResponseEntity.ok(Map.of(RESPONSE_MAP_KEY, result));
    }

    @GetMapping("/manage/{uuid}")
    public ResponseEntity<Map<String, List<FriendWaitDto>>> getFriendWaitList(@PathVariable("uuid") String uuid) throws Exception {
        return ResponseEntity.ok(Map.of(RESPONSE_MAP_KEY, friendService.getFriendWaitList(uuid)));
    }

    /* 친구 신청 받은 사람이 요청을 수락한다. */
    @PostMapping("/manage/{uuid}")
    public ResponseEntity<Map<String, String>> allowFriendRequest(@PathVariable("uuid") String uuid,
                                                                  @RequestBody Map<String, String> map) throws Exception {
        String senderUuid = map.get(SENDER_MAP_KEY);
        String result = friendService.allowFriendRequest(uuid, senderUuid);
        return ResponseEntity.ok(Map.of(RESPONSE_MAP_KEY, result));
    }

    @DeleteMapping("/manage/{uuid}")
    public ResponseEntity<Map<String, String>> refuseFriendRequest(@PathVariable("uuid") String uuid,
                                                                   @RequestBody Map<String, String> map) throws Exception {
        String senderUuid = map.get(SENDER_MAP_KEY);
        String result = friendService.refuseFriendRequest(uuid, senderUuid);
        return ResponseEntity.ok(Map.of(RESPONSE_MAP_KEY, result));
    }

    @GetMapping("/watch/{uuid}")
    public ResponseEntity<Map<String, String>> getFriendWatching(@PathVariable("uuid") String uuid) throws Exception {
        /* TODO : 접속서버 만든 후 구현하기 */
        String result = "접속서버 만든 후 구현할 예정입니다...";
        return ResponseEntity.ok(Map.of(RESPONSE_MAP_KEY, result));
    }
}

package com.example.mainservice.controller;

import com.example.mainservice.dto.VideoListDto;
import com.example.mainservice.dto.NotificationDto;
import com.example.mainservice.dto.VideoActionDto;
import com.example.mainservice.entity.Category;
import com.example.mainservice.service.MainService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
public class MainController {

    private static final String RESPONSE_MAP_KEY = "result";
    private final MainService mainService;

    /**
     * @param lastId value must be -1 for initial home view (or must be same or bigger than 0)
     */
    @GetMapping("/list")
    public ResponseEntity<VideoListDto> getHomeList(@RequestParam("category") String category,
                                                    @RequestParam("last-id") int lastId,
                                                    @RequestParam("size") int size) throws Exception {
        return ResponseEntity.ok(mainService.getHomeList(Category.valueOf(category), lastId, size));
    }

    @GetMapping("/notification/{uuid}")
    public ResponseEntity<Map<String, List<NotificationDto>>> getNotificationList(@PathVariable("uuid") String uuid)
            throws Exception {
        return ResponseEntity.ok(Map.of(RESPONSE_MAP_KEY, mainService.getNotificationList(uuid)));
    }

    @PostMapping("/action")
    public ResponseEntity<Map<String, String>> actionToVideo(@RequestBody VideoActionDto dto) throws Exception {
        String result = mainService.action(dto);
        return ResponseEntity.ok(Map.of(RESPONSE_MAP_KEY, result));
    }

    @DeleteMapping("/action")
    public ResponseEntity<Map<String, String>> cancelActionToVideo(@RequestBody VideoActionDto dto) throws Exception {
        String result = mainService.cancelAction(dto);
        return ResponseEntity.ok(Map.of(RESPONSE_MAP_KEY, result));
    }

    /* TODO : elastic search로 구현*/
    @GetMapping("/search")
    public ResponseEntity<Map<String, String>> searchVideoByKeyword(@RequestParam("keyword") String keyword,
                                                                    @RequestParam("page") int page,
                                                                    @RequestParam("size") int size) throws Exception {
        //mainService.searchVideoByKeyword(keyword, page, size);
        return ResponseEntity.ok(Map.of(RESPONSE_MAP_KEY, "This API is not developed yet...."));
    }
}

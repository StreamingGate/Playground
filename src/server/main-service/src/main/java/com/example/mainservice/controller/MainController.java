package com.example.mainservice.controller;

import java.util.List;
import java.util.Map;
import com.example.mainservice.dto.HomeListDto;
import com.example.mainservice.dto.NotificationDto;
import com.example.mainservice.dto.VideoActionDto;
import com.example.mainservice.entity.Category;
import com.example.mainservice.service.MainService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RestController
public class MainController {

    private static final String RESPONSE_MAP_KEY = "result";
    private final MainService mainService;

    /**
     * <pre>
     * {lastVideoId, lastLiveRoomId} value must be -1 for initial home view (or must be same or bigger than 0)
     * </pre>
     */
    @GetMapping("/list")
    public ResponseEntity<HomeListDto> getHomeList(@RequestParam("category") String category,
                                                   @RequestParam("last-video") long lastVideoId,
                                                   @RequestParam("last-live") long lastLiveRoomId,
                                                   @RequestParam("size") int size) throws Exception {
        return ResponseEntity.ok(mainService.getHomeList(Category.valueOf(category), lastVideoId, lastLiveRoomId, size));
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

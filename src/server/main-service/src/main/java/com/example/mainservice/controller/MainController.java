package com.example.mainservice.controller;

import com.example.mainservice.dto.HomeList;
import com.example.mainservice.dto.NotificationDto;
import com.example.mainservice.dto.SearchedList;
import com.example.mainservice.dto.VideoActionDto;
import com.example.mainservice.entity.Category;
import com.example.mainservice.service.MainService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
public class MainController {

    private final MainService mainService;

    /**
     *
     * @param category ALL(기본 홈화면 로드), 그 외(카테고리별 조회)
     */
    @GetMapping("/list")
    public HomeList getVideoList(@RequestParam("category") String category, @RequestParam("page") int page, @RequestParam("size") int size) throws Exception {
        return mainService.getVideoList(Category.valueOf(category), page, size);
    }

    @GetMapping("/alarm/{uuid}")
    public List<NotificationDto> getNotificationList(@PathVariable("uuid") String uuid) throws Exception {
        return mainService.getNotificationList(uuid);
    }

    @PostMapping("/action")
    public String actionToVideo(@RequestBody VideoActionDto dto) throws Exception {
        return mainService.action(dto);
    }

    @DeleteMapping("/action")
    public String cancelActionToVideo(@RequestBody VideoActionDto dto) throws Exception {
        return mainService.cancelAction(dto);
    }

    @GetMapping("/search")
    public SearchedList searchVideoByKeyword(@RequestParam("keyword") String keyword, @RequestParam("category") String category,
                                             @RequestParam("page") int page, @RequestParam("size") int size) throws Exception {
        return mainService.searchVideoByKeyword(keyword, Category.valueOf(category), page, size);
    }
}

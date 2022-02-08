package com.example.videoservice.controller;

import com.example.videoservice.dto.VideoResponseDto;
import com.example.videoservice.exceptionHandler.customexception.CustomVideoException;
import com.example.videoservice.service.VideoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
public class VideoController {
    private final VideoService videoService;

    @GetMapping("/video/{videoId}")
    public ResponseEntity<VideoResponseDto> getVideo(@PathVariable("videoId")Long videoId, @RequestParam("uuid") String userUuid)
            throws CustomVideoException {
        VideoResponseDto result = videoService.getVideo(videoId, userUuid);
        return ResponseEntity.ok(result);
    }
}

package com.example.uploadservice.controller;

import com.example.uploadservice.dto.UploadRequestDto;
import com.example.uploadservice.dto.VideoDto;
import com.example.uploadservice.entity.Video.Video;
import com.example.uploadservice.exceptionHandler.customexception.CustomUploadException;
import com.example.uploadservice.service.TranscodeService;
import com.example.uploadservice.service.UploadService;
import com.example.uploadservice.service.VideoService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RequestMapping("/upload")
@RestController
public class UploadController {

    private final VideoService videoService;
    private final UploadService uploadService;
    private final TranscodeService transcodeService;

    @PostMapping(consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<Map<String, String>> video(@RequestPart(value = "video") MultipartFile multipartFileVideo,
                                                     @RequestPart(value = "thumbnail", required = false) MultipartFile multipartFileThumbnail,
                                                     @RequestPart(value = "data") UploadRequestDto dto) throws CustomUploadException  {
        VideoDto videoDto = new VideoDto(dto);
        String videoUuid = uploadService.uploadRawFile(multipartFileVideo, multipartFileThumbnail, videoDto);
        transcodeService.convertMp4ToTs(videoUuid, multipartFileThumbnail);
        String s3OutputPath = uploadService.uploadTranscodedFile(videoUuid);
        videoDto.updateMetaData(s3OutputPath);
        videoService.add(videoDto);

        return ResponseEntity.ok(Map.of("result", "success"));
    }

    @PostMapping(value="/live/{roomId}", consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<Map<String, String>> live(@RequestPart(value = "video") MultipartFile multipartFileVideo,
                                                    @RequestPart(value = "thumbnail", required = false) MultipartFile multipartFileThumbnail,
                                                    @RequestPart(value = "data") UploadRequestDto dto,
                                                    @PathVariable(value = "roomId") Long roomId) throws CustomUploadException  {

        VideoDto videoDto = new VideoDto(dto);
        String videoUuid = uploadService.uploadRawFile(multipartFileVideo, multipartFileThumbnail, videoDto);
        transcodeService.convertMp4ToTs(videoUuid, multipartFileThumbnail);
        String s3OutputPath = uploadService.uploadTranscodedFile(videoUuid);
        videoDto.updateMetaData(s3OutputPath);

        Video video = videoService.add(videoDto);
        videoService.remove(video, roomId);
        return ResponseEntity.ok(Map.of("result", "success"));
    }
}

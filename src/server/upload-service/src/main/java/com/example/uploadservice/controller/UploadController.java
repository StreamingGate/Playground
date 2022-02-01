package com.example.uploadservice.controller;

import com.example.uploadservice.service.UploadService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@RequiredArgsConstructor
@RestController
public class UploadController {

    private final UploadService uploadService;

    @GetMapping("/video")
    public String video(@RequestParam("file") MultipartFile multipartFile){
        log.info("multipartFile come....");
        return uploadService.upload(multipartFile);
    }
}

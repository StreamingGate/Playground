package com.example.uploadservice.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class UploadResponseDto {
    private String outputPath; //ts파일 경로
    private String tsPath; //ts파일 경로
    private String thumbnailPath; //썸네일 경로

    public UploadResponseDto(String outputPath, String tsPath, String thumbnailPath){
        this.outputPath = outputPath;
        this.tsPath = tsPath;
        this.thumbnailPath = thumbnailPath;
    }
}

package com.example.uploadservice.dto;

import com.example.uploadservice.entity.Category;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class UploadRequestDto {
    private String title;
    private String content;
    private Category category;
    private String uuid; //uploder's uuid
}

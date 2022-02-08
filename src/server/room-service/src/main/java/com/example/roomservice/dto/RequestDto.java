package com.example.roomservice.dto;

import com.example.roomservice.entity.Category;
import lombok.Data;

@Data
public class RequestDto {
    private String hostUuid;
    private String uuid;
    private String title;
    private String content;
    private String thumbnail;
    private Category category;
}

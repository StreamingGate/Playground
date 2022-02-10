package com.example.roomservice.dto;

import com.example.roomservice.entity.Category;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ResponseDto {
    private Long roomId;
    private String uuid; // room={uuid}
    private String hostNickname;
    private String hostUuid;
    private String title;
    private String content;
    private Integer likeCnt;
    private Category category;
    private LocalDateTime createdAt;
    private Integer reportCnt;
    private String thumbnail;
    private Boolean liked;
    private Boolean disliked;

}

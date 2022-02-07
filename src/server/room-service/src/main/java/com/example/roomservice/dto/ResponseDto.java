package com.example.roomservice.dto;

import com.example.roomservice.entity.Category;
import lombok.Data;
import java.time.LocalDate;

@Data
public class ResponseDto {
    private Long roomId;
    private String uuid;
    private String hostNickname;
    private String hostUuid;
    private String content;
    private Integer likeCnt;
    private Category category;
    private LocalDate createdAt;
    private Integer reportCnt;
    private String thumbnail;
    private Boolean liked;
    private Boolean disliked;

}

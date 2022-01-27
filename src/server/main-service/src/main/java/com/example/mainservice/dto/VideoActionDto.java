package com.example.mainservice.dto;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class VideoActionDto {
    private long id;
    private int type; //0: video, 1: roomId
    private ACTION action;
    private String uuid;

    public enum ACTION{
        REPORT, LIKE, DISLIKE
    }
}

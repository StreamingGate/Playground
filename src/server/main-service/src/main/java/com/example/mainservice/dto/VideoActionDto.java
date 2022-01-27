package com.example.mainservice.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@Setter
@Getter
public class VideoActionDto {
    private long id;
    private int type;       //type of id(0: video, 1: roomId)
    private ACTION action;
    private String uuid;    //user's uuid

    public enum ACTION{
        REPORT, LIKE, DISLIKE
    }
}

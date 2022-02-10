package com.example.roomservice.dto;

import lombok.Data;

@Data
public class RequestExitDto {
    private Long roomId;
    private String hostUuid;
}

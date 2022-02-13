package com.example.chatservice.dto.room;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class RoomCreateDto {
    private String uuid;
    private String hostUuid;
}

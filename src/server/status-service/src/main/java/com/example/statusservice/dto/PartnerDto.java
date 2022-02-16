package com.example.statusservice.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class PartnerDto {
    private FriendDto requestDto;
    private FriendDto senderOrTargetDto;
}

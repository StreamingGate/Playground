package com.example.mainservice.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class PartnerDto {

    private FriendDto requestDto;
    private FriendDto senderOrTargetDto;

    public PartnerDto(FriendDto requestDto, FriendDto senderOrTargetDto){
        this.requestDto = requestDto;
        this.senderOrTargetDto = senderOrTargetDto;
    }
}

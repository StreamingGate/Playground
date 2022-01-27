package com.example.mainservice.dto;

import com.example.mainservice.entity.Notification.Notification;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class NotificationDto {

    private Notification.NotiType notiType;
    private String content;//json
}

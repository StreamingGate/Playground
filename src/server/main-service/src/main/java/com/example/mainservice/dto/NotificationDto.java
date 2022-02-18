package com.example.mainservice.dto;

import com.example.mainservice.entity.Notification.NotiType;
import lombok.Data;

@Data
public class NotificationDto {

    private NotiType notiType;
    private String content; // json
}

package com.example.mainservice.dto;

import com.example.mainservice.entity.Notification.NotiType;
import com.example.mainservice.entity.Notification.Notification;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
public class NotificationDto {

    private NotiType notiType;
    private String content;//json
}

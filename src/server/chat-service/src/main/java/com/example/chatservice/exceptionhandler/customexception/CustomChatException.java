package com.example.chatservice.exceptionhandler.customexception;

import lombok.Getter;
import org.springframework.messaging.MessagingException;

@Getter
public class CustomChatException extends MessagingException {

    private ErrorCode errorCode;
    private String uuid; //room or user uuid

    public CustomChatException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }
}

package com.example.chatservice.exception;

import lombok.Getter;

@Getter
public class CustomChatException extends RuntimeException {

    private ErrorCode errorCode;
    private String uuid; //room or user uuid

    public CustomChatException() {
        super();
    }

    public CustomChatException(ErrorCode errorCode, String uuid) {
        this.errorCode = errorCode;
        this.uuid = uuid;
    }
}

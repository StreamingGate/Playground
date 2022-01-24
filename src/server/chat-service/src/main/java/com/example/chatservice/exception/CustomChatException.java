package com.example.chatservice.exception;

import lombok.Getter;

@Getter
public class CustomChatException extends RuntimeException {

    private ErrorCode errorCode;
    private String roomId;

    public CustomChatException() {
        super();
    }

    public CustomChatException(ErrorCode errorCode, String roomId) {
        this.errorCode = errorCode;
        this.roomId = roomId;
    }
}

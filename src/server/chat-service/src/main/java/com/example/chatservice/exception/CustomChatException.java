package com.example.chatservice.exception;

import lombok.Getter;

@Getter
public class CustomChatException extends RuntimeException {

    private ErrorCode errorCode;
    private String roomId;
    private String message;

    public CustomChatException() {
        super();
    }

    public CustomChatException(ErrorCode errorCode) {
        this.errorCode = errorCode;
        this.message = errorCode.getMessage();
    }

    public CustomChatException(ErrorCode errorCode, String roomId) {
        this.errorCode = errorCode;
        this.roomId = roomId;
    }
}

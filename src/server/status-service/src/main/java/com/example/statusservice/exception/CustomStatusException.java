package com.example.statusservice.exception;

import lombok.Getter;

@Getter
public class CustomStatusException extends RuntimeException {

    private ErrorCode errorCode;
    private String roomId;

    public CustomStatusException() {
        super();
    }

    public CustomStatusException(ErrorCode errorCode, String roomId) {
        this.errorCode = errorCode;
        this.roomId = roomId;
    }
}

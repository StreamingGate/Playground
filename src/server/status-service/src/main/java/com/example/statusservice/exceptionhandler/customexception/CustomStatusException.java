package com.example.statusservice.exceptionhandler.customexception;

import lombok.Getter;

@Getter
public class CustomStatusException extends RuntimeException {

    private ErrorCode errorCode;
    private String uuid;
    private String message;

    public CustomStatusException() {
        super();
    }

    public CustomStatusException(ErrorCode errorCode) {
        this.errorCode = errorCode;
    }

    public CustomStatusException(ErrorCode errorCode, String uuid) {
        this.errorCode = errorCode;
        this.uuid = uuid;
    }

    public CustomStatusException(ErrorCode errorCode, String uuid, String message) {
        this.errorCode = errorCode;
        this.uuid = uuid;
        this.message = message;
    }
}

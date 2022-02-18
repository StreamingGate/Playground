package com.example.uploadservice.exceptionhandler.customexception;

import lombok.Getter;

@Getter
public class CustomUploadException extends RuntimeException {

    private ErrorCode errorCode;
    private String message;

    public CustomUploadException() {
        super();
    }

    public CustomUploadException(ErrorCode errorCode) {
        this.errorCode = errorCode;
    }

    public CustomUploadException(ErrorCode errorCode, String message) {
        this.errorCode = errorCode;
        this.message = message;
    }
}


package com.example.userservice.exceptionhandler.customexception;


import lombok.Getter;

@Getter
public class CustomUserException extends RuntimeException {
    private ErrorCode errorCode;
    public CustomUserException() {
        super();
    }

    public CustomUserException(ErrorCode errorCode) {
        this.errorCode = errorCode;
    }
}

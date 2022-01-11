package com.example.userservice.exceptionhandler.customexception;


import lombok.Getter;

@Getter
public class CustomUserException extends RuntimeException {
    private ErrorCode errorCode;

    public CustomUserException() {
        super();
    }

    public CustomUserException(String message) {
        super(message);
    }
    public CustomUserException(ErrorCode errorCode,String message) {
        super(message);
        this.errorCode = errorCode;
    }
}

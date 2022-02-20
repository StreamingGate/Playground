package com.example.roomservice.exceptionhandler.customexception;

import lombok.Getter;

@Getter
public class CustomRoomException extends RuntimeException {

    private ErrorCode errorCode;

    public CustomRoomException() {
        super();
    }

    public CustomRoomException(ErrorCode errorCode) {
        this.errorCode = errorCode;
    }
}


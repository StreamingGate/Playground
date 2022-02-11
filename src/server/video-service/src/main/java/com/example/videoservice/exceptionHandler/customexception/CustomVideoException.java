package com.example.videoservice.exceptionHandler.customexception;

import lombok.Getter;

/* 다른 서비스와 관련된 에러라도 여기선 커스텀 예외는 CustomVideoException.java 하나로 통일한다. */
@Getter
public class CustomVideoException extends RuntimeException {

    private ErrorCode errorCode;

    public CustomVideoException() {
        super();
    }

    public CustomVideoException(ErrorCode errorCode) {
        this.errorCode = errorCode;
    }
}


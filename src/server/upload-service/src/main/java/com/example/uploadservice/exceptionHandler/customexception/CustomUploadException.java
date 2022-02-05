package com.example.uploadservice.exceptionHandler.customexception;

import lombok.Getter;

/**
 * 다른 서비스와 관련된 에러라도 여기선 커스텀 예외는 CustomMainException.java 하나로 통일한다.
 */
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


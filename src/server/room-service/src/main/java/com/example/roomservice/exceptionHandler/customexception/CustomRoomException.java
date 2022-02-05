package com.example.roomservice.exceptionHandler.customexception;

import lombok.Getter;

/**
 * 다른 서비스와 관련된 에러라도 여기선 커스텀 예외는 CustomMainException.java 하나로 통일한다.
 */
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


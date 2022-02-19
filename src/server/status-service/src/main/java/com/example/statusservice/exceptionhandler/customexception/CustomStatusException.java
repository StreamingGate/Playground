package com.example.statusservice.exceptionhandler.customexception;

import lombok.Getter;
import org.springframework.messaging.MessagingException;

@Getter
public class CustomStatusException extends MessagingException {

    private ErrorCode errorCode;
    private String uuid;
    private String message;

    public CustomStatusException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
        this.message = errorCode.getMessage();
    }

    public CustomStatusException(ErrorCode errorCode, String uuid) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
        this.message = errorCode.getMessage();
        this.uuid = uuid;
    }

    public CustomStatusException(ErrorCode errorCode, String uuid, String message) {
        super(message);
        this.errorCode = errorCode;
        this.message = message;
        this.uuid = uuid;
    }
}

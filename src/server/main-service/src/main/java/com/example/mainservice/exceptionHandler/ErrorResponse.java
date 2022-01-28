package com.example.mainservice.exceptionHandler;

import com.example.mainservice.exceptionHandler.customexception.ErrorCode;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class ErrorResponse {
    private ErrorCode errorCode;
    private String message;
}

package com.example.mainservice.exceptionhandler;

import com.example.mainservice.exceptionhandler.customexception.ErrorCode;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class ErrorResponse {
    private ErrorCode errorCode;
    private String message;
}

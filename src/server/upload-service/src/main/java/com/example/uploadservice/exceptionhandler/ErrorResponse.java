package com.example.uploadservice.exceptionhandler;

import com.example.uploadservice.exceptionhandler.customexception.ErrorCode;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class ErrorResponse {
    private ErrorCode errorCode;
    private String message;
}

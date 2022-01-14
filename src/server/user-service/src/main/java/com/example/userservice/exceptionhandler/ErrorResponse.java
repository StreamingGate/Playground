package com.example.userservice.exceptionhandler;

import com.example.userservice.exceptionhandler.customexception.ErrorCode;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class ErrorResponse {
    private ErrorCode errorCode;
    private String message;
}

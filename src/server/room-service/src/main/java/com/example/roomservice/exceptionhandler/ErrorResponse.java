package com.example.roomservice.exceptionhandler;

import com.example.roomservice.exceptionhandler.customexception.ErrorCode;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class ErrorResponse {
    private ErrorCode errorCode;
    private String message;
}

package com.example.uploadservice.exceptionhandler;

import com.example.uploadservice.exceptionhandler.customexception.CustomUploadException;
import com.example.uploadservice.exceptionhandler.customexception.ErrorCode;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ExceptionController {

    @ExceptionHandler(CustomUploadException.class)
    public ResponseEntity<ErrorResponse> handleExceptions(CustomUploadException e) {
        ErrorResponse response = getErrorResponse(e);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    private ErrorResponse getErrorResponse(CustomUploadException e){
        if(e.getErrorCode() == ErrorCode.I001){
            return new ErrorResponse(e.getErrorCode(), e.getMessage());
        }
        return new ErrorResponse(e.getErrorCode(), e.getErrorCode().getMessage());
    }
}

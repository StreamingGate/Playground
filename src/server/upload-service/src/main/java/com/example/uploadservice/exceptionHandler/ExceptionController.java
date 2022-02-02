package com.example.uploadservice.exceptionHandler;

import com.example.uploadservice.exceptionHandler.customexception.CustomUploadException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ExceptionController {

    @ExceptionHandler(CustomUploadException.class)
    public ResponseEntity<ErrorResponse> handleExceptions(CustomUploadException e) {
        ErrorResponse response = new ErrorResponse(e.getErrorCode(), e.getErrorCode().getMessage());
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
}

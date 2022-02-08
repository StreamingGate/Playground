package com.example.videoservice.exceptionHandler;

import com.example.videoservice.exceptionHandler.customexception.CustomVideoException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ExceptionController {

    @ExceptionHandler(CustomVideoException.class)
    public ResponseEntity<ErrorResponse> handleExceptions(CustomVideoException e) {
        ErrorResponse response = new ErrorResponse(e.getErrorCode(), e.getErrorCode().getMessage());
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
}

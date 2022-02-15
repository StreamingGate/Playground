package com.example.mainservice.exceptionhandler;

import com.example.mainservice.exceptionhandler.customexception.CustomMainException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ExceptionController {

    @ExceptionHandler(CustomMainException.class)
    public ResponseEntity<ErrorResponse> handleExceptions(CustomMainException e) {
        ErrorResponse response = new ErrorResponse(e.getErrorCode(), e.getErrorCode().getMessage());
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
}

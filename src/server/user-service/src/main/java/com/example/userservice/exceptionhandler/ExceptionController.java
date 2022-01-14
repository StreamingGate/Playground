package com.example.userservice.exceptionhandler;

import com.example.userservice.exceptionhandler.customexception.CustomUserException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class ExceptionController {

    @ExceptionHandler(CustomUserException.class)
    public ResponseEntity<ErrorResponse> handleCreateUser(CustomUserException e) {
        ErrorResponse response = new ErrorResponse(e.getErrorCode(), e.getErrorCode().getMessage());
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
}

package com.example.roomservice.exceptionHandler;

import com.example.roomservice.exceptionHandler.customexception.CustomRoomException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ExceptionController {

    @ExceptionHandler(CustomRoomException.class)
    public ResponseEntity<ErrorResponse> handleExceptions(CustomRoomException e) {
        ErrorResponse response = new ErrorResponse(e.getErrorCode(), e.getErrorCode().getMessage());
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
}

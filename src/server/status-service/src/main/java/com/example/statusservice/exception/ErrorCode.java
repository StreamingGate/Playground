package com.example.statusservice.exception;

import lombok.Getter;

@Getter
public enum ErrorCode {
    S001(""), // custom message template
    S002("존재하지 않는 헤더 키입니다.");
    private String message;

    ErrorCode (String message){
        this.message = message;
    }
}

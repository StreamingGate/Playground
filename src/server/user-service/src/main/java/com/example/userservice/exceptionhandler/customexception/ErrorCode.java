package com.example.userservice.exceptionhandler.customexception;

import lombok.Getter;

@Getter
public enum ErrorCode {
    U001("이미 존재하는 회원입니다."),
    U002("존재하지 않는 회원입니다."),
    U003("이미 사용중인 닉네임 입니다.");

    private final String message;

    ErrorCode(String message) {
        this.message = message;
    }
}
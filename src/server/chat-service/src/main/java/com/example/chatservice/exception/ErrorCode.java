package com.example.chatservice.exception;

import lombok.Getter;

@Getter
public enum ErrorCode {
    C001("요청 권한이 유효하지 않습니다."), // 일반채팅
    C002("존재하지 않는 헤더 키입니다."),
    C003("토큰이 만료되었습니다."),
    C004("토큰의 타입 또는 값이 유효하지 않습니다."),
    C005("토큰의 시그니쳐가 유효하지 않습니다."),
    C006("유효한 유저의 토큰이 아닙니다.");
    private String message;

    ErrorCode (String message){
        this.message = message;
    }
}

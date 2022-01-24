package com.example.userservice.exceptionhandler.customexception;

import lombok.Getter;

@Getter
public enum ErrorCode {
    U001("이미 존재하는 회원입니다."),
    U002("존재하지 않는 회원입니다."),
    U003("인증코드가 틀렸습니다."),
    U004("이미 사용중인 닉네임 입니다."),
    U005("회원정보가 올바르지 않습니다."),
    U006("이미지를 찾을수 없습니다.");


    private final String message;

    ErrorCode(String message) {
        this.message = message;
    }
}
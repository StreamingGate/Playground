package com.example.uploadservice.exceptionHandler.customexception;

import lombok.Getter;

@Getter
public enum ErrorCode {
    U001("이미 존재하는 회원입니다."),
    U002("존재하지 않는 회원입니다."),
    U003("인증코드가 틀렸습니다."),
    U004("이미 사용중인 닉네임 입니다."),
    U005("회원정보가 올바르지 않습니다."),
    U006("이미지를 찾을수 없습니다."),

    V001("존재하지 않는 일반 영상입니다."),

    L001("존재하지 않는 실시간 스트리밍입니다."),


    F001("해당 유저로부터 받은 친구 요청이 존재하지 않습니다."),
    F002("이미 해당 유저에게 친구 신청을 보냈습니다."),
    F003("이미 친구인 유저입니다."),
    F004("친구가 아닌 유저입니다.");
    private final String message;

    ErrorCode(String message) {
        this.message = message;
    }
}
package com.example.userservice.entity.User;

import lombok.Getter;

@Getter
public enum UserState {
    STEADY("stedy"),
    QUIT("quit"),
    WARNED("warned");

    private final String state;

    UserState(String state){
        this.state = state;
    }
}

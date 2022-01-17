package com.example.mainservice.entity.User;

import lombok.Getter;

@Getter
public enum UserState {
    STEADY("steady"),
    QUIT("quit"),
    WARNED("warned");

    private final String state;

    UserState(String state){
        this.state = state;
    }
}

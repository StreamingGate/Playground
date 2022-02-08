package com.example.statusservice.dto.login;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@NoArgsConstructor
@Data
public class LoginDto implements Serializable {

    private static final long serialVersionUID = 1234678977089006638L;

    private String uuid;
    private LoginStatus status;
}

package com.example.userservice.configure.security;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Base64;
import java.util.Date;

@RequiredArgsConstructor
@Component
public class Jwt {

    @Value("${jwts.secret-key}")
    private String SECRET_KEY;
    private long ACCESS_TIME = 60 * 60 * 1000L; //1시간
    private long REFRESH_TMIE = 60 * 60 * 24 * 7 * 1000L; //1주일

    public String createToken(String uuid) {
        String secretKey = Base64.getEncoder().encodeToString(SECRET_KEY.getBytes());
        String token = Jwts.builder()
                .setSubject(uuid)
                .setExpiration(new Date(System.currentTimeMillis() + ACCESS_TIME))
                .signWith(SignatureAlgorithm.HS512, secretKey)
                .compact();
        return token;
    }

    public String createRefreshToken(String uuid) {
        String secretKey = Base64.getEncoder().encodeToString(SECRET_KEY.getBytes());
        String refreshToken = Jwts.builder()
                .setSubject(uuid)
                .setExpiration(new Date(System.currentTimeMillis() + REFRESH_TMIE))
                .signWith(SignatureAlgorithm.HS512, secretKey)
                .compact();
        return refreshToken;
    }

    public String getUserUuid(String token) {
        String secretKey = Base64.getEncoder().encodeToString(SECRET_KEY.getBytes());
        return Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token).getBody().getSubject();
    }
}

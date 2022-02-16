package com.example.statusservice.redis;

import com.example.statusservice.entity.User.UserRepository;
import com.example.statusservice.exceptionhandler.customexception.CustomStatusException;
import com.example.statusservice.exceptionhandler.customexception.ErrorCode;
import io.jsonwebtoken.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class JwtService {

    private static String SECRET_KEY;
    private UserRepository userRepository;

    @Autowired
    public JwtService(UserRepository userRepository, @Value("${jwts.secret-key}") String SECRET_KEY){
        this.userRepository = userRepository;
        this.SECRET_KEY = SECRET_KEY;
    }

    /**
     * @param token
     * @return true if token is valid
     * @throws CustomStatusException
     */
    public boolean validation(String token) throws CustomStatusException{
        if (token != null && isTokenValid(token)) {
            String uuid = getUuid(token);
            userRepository.findByUuid(uuid).orElseThrow(() -> new CustomStatusException(ErrorCode.S003, uuid));
            return true;
        }
        return false;
    }

    private boolean isTokenValid(String token){
        try {
            Jwts.parser().setSigningKey(SECRET_KEY.getBytes()).parseClaimsJws(token);
        } catch (ExpiredJwtException e) {
            return false;
        } catch (UnsupportedJwtException | MalformedJwtException | IllegalArgumentException e) {
            return false;
        } catch (SignatureException e) {
            return false;
        }
        return true;
    }

    private String getUuid(String token) {
        return (String) Jwts.parser().setSigningKey(SECRET_KEY.getBytes()).parseClaimsJws(token).getBody().getSubject();
    }
}
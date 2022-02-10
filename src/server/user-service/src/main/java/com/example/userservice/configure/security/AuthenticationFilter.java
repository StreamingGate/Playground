package com.example.userservice.configure.security;

import com.example.userservice.dto.user.UserDto;
import com.example.userservice.service.UserService;
import com.example.userservice.dto.user.RequestLogin;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Slf4j
@RequiredArgsConstructor
public class AuthenticationFilter extends UsernamePasswordAuthenticationFilter {
    private final UserService userService;
    private final RedisTemplate<String,Object> redisTemplate;
    private final Jwt jwt;
    private long REFRESH_TMIE = 60 * 60 * 24 * 7 * 1000L;

    public AuthenticationFilter(AuthenticationManager authenticationManager,
                                UserService userService, RedisTemplate<String, Object> redisTemplate,Jwt jwt) {
        super.setAuthenticationManager(authenticationManager);
        this.redisTemplate = redisTemplate;
        this.userService = userService;
        this.jwt = jwt;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request,
                                                HttpServletResponse response) throws AuthenticationException {
        try {
            RequestLogin creds = new ObjectMapper().readValue(request.getInputStream(),RequestLogin.class);
            return getAuthenticationManager().authenticate(
                    new UsernamePasswordAuthenticationToken(creds.getEmail(),creds.getPassword(),new ArrayList<>())
            );
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void successfulAuthentication(HttpServletRequest request,
                                            HttpServletResponse response,
                                            FilterChain chain,
                                            Authentication authResult) throws IOException, ServletException {
        String userEmail = ((User)authResult.getPrincipal()).getUsername();
        UserDto userDto = userService.getUserByEmail(userEmail);
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, DELETE, PUT");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type,Access-Control-Allow-Headers, " +
                "Authorization,Accept,X-Requested-With,observe,Content-Length");
        response.setHeader("Access-Control-Expose-Headers","uuid,token,refreshToken");
        response.setContentType("application/json");
        response.setCharacterEncoding("utf-8");

        if(request.getMethod().equals(HttpMethod.OPTIONS.name())) {
            response.setStatus(HttpStatus.OK.value());
        }

        String token = jwt.createToken(userDto.getUuid());
        String refreshToken = jwt.createRefreshToken(userDto.getUuid());
        redisTemplate.opsForValue().set(refreshToken,userDto.getUuid(),REFRESH_TMIE, TimeUnit.SECONDS);

        response.addHeader("refreshToken",refreshToken);
        response.addHeader("uuid",userDto.getUuid());
        response.addHeader("token",token);
        res.put("email",userDto.getEmail());
        res.put("name",userDto.getName());
        res.put("nickName",userDto.getNickName());
        res.put("profileImage",userDto.getProfileImage());
        JSONObject object = new JSONObject(res);
        response.getWriter().write(String.valueOf(object));
    }
}

package com.example.apigateway.filter;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@Component
public class AuthenticationFilter extends AbstractGatewayFilterFactory<AuthenticationFilter.Config> {

    public static class Config {}
    public AuthenticationFilter() {
        super(Config.class);
    }

    @Value("${jwts.secret-key}")
    private String SECRET_KEY;

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            ServerHttpRequest request = exchange.getRequest();
            if(!request.getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {
                return onError(exchange,"You don't have authorization header", HttpStatus.UNAUTHORIZED);
            } //Authorization
            String authorizationHeader =  request.getHeaders().get("Authorization").get(0);
            String jwt = authorizationHeader.replace("Bearer ","");
            if (!isJwtValid(jwt)) {
                return onError(exchange,"JWT is not valid", HttpStatus.UNAUTHORIZED);
            }
            return chain.filter(exchange);
        };
    }

    private Mono<Void> onError(ServerWebExchange exchange, String errorMsg, HttpStatus httpStatus) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(httpStatus);
        return response.setComplete();
    }
    private boolean isJwtValid(String jwt) {
        boolean res = true;
        try {
            Claims accessClaims = Jwts.parser().setSigningKey(SECRET_KEY.getBytes())
                    .parseClaimsJws(jwt)
                    .getBody();
        }
        catch (ExpiredJwtException exception) {
            res = false;
        }
        catch (JwtException exception) {
            res = false;
        }
        catch (NullPointerException exception) {
            res = false;
        }
        return res;
    }

}

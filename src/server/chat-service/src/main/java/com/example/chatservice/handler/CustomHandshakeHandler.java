//package com.example.chatservice.handler;
//
//import com.example.chatservice.model.stomp_principal.StompPrincipal;
//import org.springframework.http.server.ServerHttpRequest;
//import org.springframework.web.socket.WebSocketHandler;
//import org.springframework.web.socket.server.support.DefaultHandshakeHandler;
//
//import java.security.Principal;
//import java.util.Map;
//import java.util.UUID;
//
///**
// * 웹소켓의 세션이 연결될 때 UUID를 생성해주는 핸들러
// */
//public class CustomHandshakeHandler extends DefaultHandshakeHandler {
//    @Override
//    protected Principal determineUser(ServerHttpRequest request,
//                                      WebSocketHandler wsHandler,
//                                      Map<String, Object> attributes) {
//        return new StompPrincipal(UUID.randomUUID().toString());
//    }
//}
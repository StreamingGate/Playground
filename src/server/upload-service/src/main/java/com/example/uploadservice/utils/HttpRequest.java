package com.example.uploadservice.utils;


import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Slf4j
@Component
public class HttpRequest {

    private static String URL;
    private static final RestTemplate restTemplate = new RestTemplate();

    @Autowired
    public HttpRequest(@Value("${service.ip.chat-service}")String chatService){
        this.URL = chatService;
    }

    /* 채팅방 생성 */
    public static void sendAddChatRoom(String uuid){
        try{
            HttpEntity<?> body = new HttpEntity<>(Map.of("uuid", uuid));
            restTemplate.postForLocation(URL+"/chat/room", body);
            log.info("create chat room 요청 완료");
        }catch(RestClientException e){
            log.warn(e.getMessage());
        }
    }
}

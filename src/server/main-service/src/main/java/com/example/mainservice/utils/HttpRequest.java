package com.example.mainservice.utils;

import com.example.mainservice.dto.FriendDto;
import com.example.mainservice.dto.PartnerDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
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
    public HttpRequest(@Value("${service.ip.status-service}")String chatService){
        this.URL = chatService;
    }

    /* 친구 추가 chat-service에 반영 */
    public static void sendAddFriend(FriendDto requestDto, FriendDto senderDto) {
        String targetURL = URL + "/friend";
        PartnerDto partnerDto = new PartnerDto(requestDto, senderDto);
        try{
            HttpEntity<?> body = new HttpEntity<>(partnerDto);
            log.info("request url:" + targetURL);
            restTemplate.exchange(targetURL, HttpMethod.POST, body, Map.class);
            log.info("add friend 완료");
        } catch(RestClientException e){
            log.warn("add friend 실패:" +e.getMessage());
        }
    }

    /* 친구 삭제 chat-service에 반영 */
    public static  void sendDeleteFriend(FriendDto requestDto, FriendDto senderDto) {
        String targetURL = URL + "/friend";
        PartnerDto partnerDto = new PartnerDto(requestDto, senderDto);
        try{
            HttpEntity<?> body = new HttpEntity<>(partnerDto);
            log.info("request url:" + targetURL);
            restTemplate.exchange(targetURL, HttpMethod.DELETE, body, Map.class);
            log.info("delete friend 완료");
        } catch(RestClientException e){
            log.warn("delete friend 실패:" +e.getMessage());
        }
    }
}

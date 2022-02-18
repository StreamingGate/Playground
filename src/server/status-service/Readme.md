# Status-Service
유저의 상태(로그인, 로그아웃)를 친구에게 보여주기 위한 서비스이며 웹소켓 테스트를 위한 클라이언트가 포함돼있습니다. 

# 사용 기술
* Spring boot 2.6
* WebSocket, SockJS, Stomp
* Mustache
* Redis

# API
* [WebSocket] 로그인 상태 전송
* [WebSocket] 로그아웃 상태 전송
* [WebSocket] 현재 시청 중인 영상 정보 전송

# 서버 실행시 필요한 yml
추가 위치: `resources/`  
application-jwt.yml
```
jwts:
    secret-key: token_secret
```

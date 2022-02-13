# Chat-Serivce
실시간 채팅을 위한 서비스이며 웹소켓 테스트를 위한 클라이언트가 포함돼있습니다.  
Redis를 사용해 여러개의 채팅서버를 실행시켜도 채팅방 메시지를 서로 동기화할 수 있도록 했습니다.

# 사용 기술
* Spring boot 2.6
* WebSocket, SockJS, Stomp
* Mustache
* Redis

# API
* [REST] 채팅방 하나 정보 조회
* [REST] 채팅방 생성
* [WebSocket] 방 입장
* [WebSocket] 채팅 전송


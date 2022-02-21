작성자: 김하늬  
작성일: 2022-02-21  
문서 설명: 서버개발 시 고민했던 내용들을 문서로 정리했습니다.


## 목차

1) 상태 관리 서버: 친구의 온라인 여부 확인하기
2) `Utils`를 사용하는 새로운 이유
3) 페이지네이션 성능 높이기

## 1) 상태 관리 서버: 친구의 온라인 여부 확인하기

배경) 친구의 온라인 여부를 실시간으로 확인하는 기능을 만들기 위해 유저스토리 정리하면서 구현 방법을 고민해보았다.

문제) 유저의 친구 목록에 본인의 상태관리를 브로드캐스팅하는 방법 생각하기  

고민)  
내가 생각하는 Redis data modeling

![image](https://user-images.githubusercontent.com/30483337/154919345-9952357c-1884-4b62-bf58-258be6ba9b20.png)
> USER_LIST(Key), user_uuid(HashKey), friends(HashValue)

유저스토리
1. 친구가 추가되면 → RDB에 추가 Redis에 put(친구 업데이트)
**첫 친구라면** USER_LIST의 elem으로 없음→ elem추가, elem의 친구 리스트 추가해주기

2. 로그인
1) publish : /topic/online/my/{my uuid}→ 내 친구 리스트에 pub함 O(n)의 시간이 걸린다.  
**body:{"uuid":{uuid}, "status":{status}}**

2) subscribe : /topic/online/{myuuid}
**body:{"uuid":{uuid}, "status":{status}}**

시나리오:{myuuid}가 접속하면 해당 친구리스트에 O(n)동안 publish됨. → {myuuid} 구독자는 body가 포함된 메시지에서 uuid를 얻어 친구 리스트에 반영함...


3. 로그아웃
1) publish: /topic/offline/my/{my uuid}
2) unsubscribe : /topic/online/{my uuid}

4. 친구 삭제 
RDB에서 삭제, Redis에 반영한다.(친구 업데이트)

### `+` 추가 기능에 대한 보완
채팅서버와 별개로 실시간 접속관리서버를 하나 둔다. (내부 데이터: 온라인여부, 보고있는 영상 링크/영상 제목)

고려할 Event)
1. 로그인하면 유저 서버 → 접속 서버로 상태변경을 요청한다.(online)
2. 영상링크를 클릭하면 접속 서버로 상태변경을 요청한다.(시청 중인 동영상)

부하관리)
실시간으로 처리하면 부하가 너무 클 것임... => polling을 고려해보자. (서버단에서 스케쥴링 or 클라이언트단에서 주기적으로 요청보내기 선택)
> 사용자가 빈번하게 들락날락하면 서버에 부하가 클 것이므로 http long polling방식을 사용할 수도 있었지만, 결국엔
> 실시간성을 강조한 서비스를 만들고 싶었기 때문에 채팅서버, 상태 관리 서버 모두 WebSocket, Stomp를 사용했다!

---
## 2) `Utils`를 사용하는 새로운 이유
여기서 Utils라 함은 인스턴스를 생성하지 않도록 내부 필드, 메서드를 static으로 선언해서 Utils.foo() 처럼 호출이 가능한 클래스를 말한다.
이렇게 하는 이유는 보통 여러 service 단에서 많이 사용하는 기능들을 한 곳에 static으로 모아둬서 메모리 낭비를 줄이려고 하는거다.
그런데 나는 Utils가 필요한 케이스를 하나 더 만났다.
그건 빈 순환참조를 풀어낼 때이다.

빈 순환 참조를 풀어내도록 유틸로 만든 소스는 아래에 있다.
- [Chat-service의 ClientMessaging.java](https://stove-developers-gitlab.sginfra.net/stove-dev-camp-2nd/streaminggate/-/blob/main/src/server/chat-service/src/main/java/com/example/chatservice/utils/ClientMessaging.java)
- [Chat-service의 RedisMessaging.java](https://stove-developers-gitlab.sginfra.net/stove-dev-camp-2nd/streaminggate/-/blob/main/src/server/chat-service/src/main/java/com/example/chatservice/utils/RedisMessaging.java)

### 문제 상황)
StompHandler.java를 추가하려보니..      
WebSocketConfig.java → StompHandler.java 의존성 필요 - (2)
```
@Configuration
@EnableWebSocketMessageBroker→DelegatingWebSocketMessageBrokerConfiguration.class 의존성 필요 - (1)

public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

  private final StompHandler stompHandler;

 //....
}
```


StompHandler.java→ ....SimpMessageSendingOperations.class 의존성 필요 - (3)
```
public class StompHandler implements ChannelInterceptor {

    private final RedisRoomService redisRoomService;

    //...
}
```

또한 SimpMessageSendingOperations.class는 내부적으로 DelegatingWebSocketMessageBrokerConfiguration.class - (4)에 의존한다.
=> 즉, 의존관계가 아래처럼 된다.

```
SimpMessageSendingOperations.java→@EnableWebSocketMessageBroker 붙은 WebSocketConfig.java→StompHandler.java→ ....→SimpMessageSendingOperations.java
```

### 해결 방안 고민)
처음엔 @Configuration 파일에 빈 생성, 주입을 선언해서 의존관계를 풀어내려고 했다.

하지만
- WebConfig.java에선 반드시 StompHandler.java에 의존해야한다.
- StompHandler.java 는 반드시 SimpMessageSendingOperations.class에 의존해야한다.
- SimpMessageSendingOperations.class는 반드시 DelegatingWebSocketMessageBrokerConfiguration.class에 의존해야한다.

이 관계 때문에 기존에 빈 순환 참조를 생성하지 않던 상태에서 StompHandler를 추가하는게 부담이 컸다.  

그래서.. 현재로선 갖다쓰기만하면 문제가 되는 SimpMessageSendingOperations.class를 자동 빈주입하지 않아도 되는 방법으로서 Utils로 선언하는 방법을 생각해냈다.

### 해결)
SimpMessageSendingOperations.class를 ClientMessaging 유틸 클래스의 필드로 선언했다.

**=> 이렇게하니까 메모리 낭비하지 않고, 자주사용하는 기능들을 모아둘 수 있고, 빈 순환 참조를 풀어낼 수 있었다.**

---
## 3) 페이지네이션 성능 높이기
배경: main-service 구현 중 무한 스크롤 기능을 위해 `단순 페이지네이션`을 구현해봤다.   
그런데 페이지 인덱스가 아닌 마지막 비디오의 pk를 기준으로 n개를 조회했어야했다.
(단순히 페이지 번호별로 조회하면 안되는 이유: 한번 조회후 중간에 영상이 하나 업로드될 경우 이미 조회한 영상을 또 조회해버릴 수도 있기 때문이다)

=> 따라서, **마지막 비디오의 pk를 기준으로 n개**를 페이지네이션하려면 어떤 방법이 적절한지 알아보려고 함. (나는 페이지네이션을 잘 모름)
> 참고)https://thalals.tistory.com/246

### 우선, 페이지네이션의 이점
페이지네이션을 사용하면 `가독성`의 문제와 `자원낭비` 문제점을 보완해주는 이점을 얻을 수 있어야한다. (이게 아니면 굳이 페이지네이션이라고 이름 붙일 이유가 없음)

페이징 쿼리 방법으로는 크게 3가지가 있음
```
ROWNUM(ORACLE, Mari DB),
LIMIT(MySQL, Maria DB),→ 우리
TOP(MSSQL)
```

### 기본 문법 `LIMIT`
limit 은 몆개의 데이터를 가져올지를 의미한다고 한다.

예)
```
SELECT * FROM post LIMIT 3;  #페이지 사이즈
SELECT * FROM post LIMIT5,3; #시작위치, 페이지 사이즈
SELECT * FROM post ORDERS LIMIT 숫자 offset 페이지 넘버; #offset으로 시작 위치를 정할 수도 있다.
```

### LIMIT 성능 이슈
limit은 내부 인덱스를 타지 않기 때문에 시작지점이 뒤쪽일 수록 시간이 오래 걸린다고 함.

```
ex. select * from post limit 1000000, 100;
```

참고로 글의 작성자가 성능 테스트한 결과를 보면 WHERE문을 사용할 때 INDEX를 타면서 매우 좋은 성능을 내는 것을 볼 수 있고,
이건 커서 기반 페이지네이션을 사용하기 때문이라고 한다. 

참고)
- 오프셋 기반 페이지네이션(Offset-based Pagination) -> 페이지 단위로 구분 
- 커서 기반 페이지네이션(Cursor-based Pagination) -> 현재 row 순서상의 다음 row들의 n개를 응답


### 나에게 적용
따라서 나도 JPQL을 작성할 때 WHERE문을 사용해 INDEX를 타서 성능 이점을 취하도록 작성했다.

[Main-Service의 VideoRepository.java](https://stove-developers-gitlab.sginfra.net/stove-dev-camp-2nd/streaminggate/-/blob/main/src/server/main-service/src/main/java/com/example/mainservice/entity/Video/VideoRepository.java)

```yaml
@Query("SELECT v FROM Video v ORDER BY v.createdAt DESC, v.id DESC")
Page<Video> findAll(Pageable pageable);

@Query("SELECT v FROM Video v WHERE v.id < :lastId ORDER BY v.createdAt DESC, v.id DESC")
Page<Video> findAll(@Param("lastId") long lastId, Pageable pageable);
```

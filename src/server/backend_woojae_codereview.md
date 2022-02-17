# 이우재 코드 리뷰 가이드

## Spring Cloud
### 서비스 소개
마이크로서비스 개발, 배포, 운영에 필요한 기술을 지원하는 Spring boot기반 프레임워크 입니다.\
service discovery인 eureka와 gateway는 Spring cloud Gateway를 사용하였습니다.

### 코드 링크
- [Spring Cloud code link](https://github.com/StreamingGate/Playground/tree/develop-server/src/infra)

## User-service
### 서비스 소개
- 유저 정보에 대한 전반적인 기능과 인증 서비스 기능 역할을 하고 있습니다. 
회원가입,수정,탈퇴와 프로필사진 삽입,수정,삭제 \
  그리고 인증 서비스 기능을 수행합니다. 인증서비스는 WebSecurity 라이브러리를 활용하여 구현 하였습니다.
  

- 프로필 사진은 S3에 유저의 고유 uuid로 저장합니다. 또한 각각의 페이지 이동시마다 프로필 이미지를 불러오기 때문에\
CloudFront(CDN)를 사용하여 이미지를 가져올때 캐시를 사용하여 가져오게 적용하였습니다. 
  

### 코드 링크
- [User service code link](https://github.com/StreamingGate/Playground/tree/develop-server/src/server/user-service)
### 기술스택
* JAVA 11
* Gradle
* Spring boot
* Jwt
* SMTP
* JPA
* Docker
* WebSecurity
* Redis
* AWS S3 SDK
---
### API
* 회원가입
* 회원정보 수정
* 비밀번호 수정, 찾기
* 토큰 관련 api
* 회원 탈퇴
* 이메일 인증
* 시청한 동영상 목록 조회
* 좋아요 누른 영상 목록 조회
* 내가 업로드한 목록 조회
---
### Etc.
```
application-s3.yml 생성 필요
ex) 
cloud:
  aws:
    stack:
      auto: false
    region:
      static: us-east-2
    credentials:
      access-key: { Access Key }
      secret-key: { Secret Key }
    s3:
      bucket: { bucket name }
```
```
application-auth.yml 생성필요
ex)
playground:
  mail:
    username: { email }
    password: { password }

jwts:
  secret-key: { hashing secret key }
```
---
## Room-service

### 서비스 소개
- 실시간 스트리밍 방을 생성하는 서비스입니다. 실시간 스트리밍 생성시 필요한 고유 uuid와 실시간 채팅에 필요한
고유 uuid를 통일하여 방을 생성합니다. \
또한 방생성시 스트리머도 그 방을 시청한것이기에 시청기록 리스트에 동시에 저장하도록 로직을 구성하였습니다.
- user-service와 마찬가지로 썸네일 이미지도 S3에 저장하고 이를 CloudFront에서 가져오도록 구현 하였습니다.
### 코드 링크
- [Room service code link](https://github.com/StreamingGate/Playground/tree/develop-server/src/server/room-service)
### 기술스택
* JAVA 11
* Gradle
* Spring boot
* JPA
* Docker
* AWS S3 SDK
---
### API
* 방 참가
* 방 생성
* 방 생성 가능 여부
* 방 종료
--- 
### 주요 기능
- 

---
### Etc.
```
application-s3.yml 생성 필요
ex) 
cloud:
  aws:
    stack:
      auto: false
    region:
      static: us-east-2
    credentials:
      access-key: { Access Key }
      secret-key: { Secret Key }
    s3:
      bucket: { bucket name }
```

## MediaSoup (미디어 서버)

### 서비스 소개
실시간 스트리밍에 필요한 미디어 서버입니다. 여러 미디어 서버 종류가 있으나, 저희팀은 Mediasoup 프레임워크를
사용 하였습니다. 

### 코드 링크
- [Mediasoup server code link](https://github.com/StreamingGate/Playground/tree/develop-server/src/server/mediasoup)

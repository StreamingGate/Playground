# 이우재 코드 리뷰 가이드

## user-service
### 서비스 소개
유저 정보에 대한 전반적인 기능과 인증 서비스 기능 역할을 하고 있습니다. 
회원가입,수정,탈퇴와 프로필사진 삽입,수정,삭제 그리고 인증 서비스 기능을 수행합니다. 

### 코드 링크
- https://github.com/StreamingGate/Playground/tree/develop-server/src/server/user-service
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
실시간 스트리밍 방을 생성하는 서비스입니다. 실시간 스트리밍 생성시 필요한 고유 uuid와 실시간 채팅에 필요한
고유 uuid를 통일하여 방을 생성합니다.
### 코드 링크
- https://github.com/StreamingGate/Playground/tree/develop-server/src/server/room-service
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
- https://github.com/StreamingGate/Playground/tree/develop-server/src/server/mediasoup
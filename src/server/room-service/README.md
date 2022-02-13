##서비스 소개
실시간 스트리밍 방을 생성하는 서비스입니다. 실시간 스트리밍 생성시 필요한 고유 uuid와 실시간 채팅에 필요한
고유 uuid를 통일하여 방을 생성합니다. 
## 기술스택
* JAVA 11
* Gradle
* Spring boot
* JPA
* Docker
* AWS S3 SDK
---
## API
* 방 참가
* 방 생성
* 방 생성 가능 여부
* 방 종료
--- 
##Etc.
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
## 기술스택
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
## API
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
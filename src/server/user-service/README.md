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
### 주요 기능
- 회원가입시 프로필 사진을 업로드하는데 이때 BASE64 형식으로 이미지를 전달합니다. \
  로컬에 저장후 S3에 업로드 하는것은 보안상 좋지 않다고 생각했고 저장할때, 이를 업로드할때 에러 핸들링할때도 신경쓸게 많아질거라 판단했습니다.\
  또한 BASE 64형식으로 보낸다면 용량은 1.5mb이하로 보내야 정상 처리 되기에 자연스럽게 용량에도 제한을 둬서 S3 스토리지 용량관리에도 용이하다고 생각했습니다.


- 토큰은 엑세스 토큰과 리플레쉬 토큰을 생성하여 헤더에 담아 리스폰합니다. 토큰 체크는 web Security를 이용하여 체크합니다. \
  추후 엑세스 토큰이 만료 되었다면, 토큰 만료 에러를 반환하고 클라이언트측은 토큰 재발급을 요청합니다.


- 마이페이지에서 시청기록을 가져올때 실시간 스트리밍 DB Table과 비디오 DB Table 두곳에서 시간 역순으로 가져오는데
  이를 하나로 묶어 리스폰할때는 두 리스트끼리 또 한번 시간순으로 정렬후 리스폰 해야했습니다.\
  이를 HistoryService를 통해 정렬하는데 투포인터 알고리즘을 사용하여 두 리스트에서 각각의 값을 비교하며 시간 역순으로 재정렬 합니다.\
  현재 실시간 스트리밍을 동영상으로 저장할수 없어서 사용하지 않습니다. 추후 실시간 스트리밍도 저장이 가능해진다면
  필요한 기능이기에 남겨 두었습니다.
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
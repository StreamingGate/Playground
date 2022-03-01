StreamingGate
---

각 empty folder를 git에 add하기 위해 만든 `.gitkeeper`는 해당 폴더에 파일을 추가하게 되면 지워주세요

### CRLF(Windows)/LF(Linux, MAC) 관련 git 설정하기

`.gitattributes` 로 텍스트 파일의 속성을 설정했지만, 모든 소스파일을 검사해주지 않거나 확신이 들지 않는다면 
아래를 로컬에서 설정해주세요

- Windows
```
git config --global core.autocrlf true
```

- Linux, MAC
```
git config --global core.autocrlf input
```

---
# Playground

# 실행화면
## 클라이언트 (iOS)

| 메인페이지 | 비디오 플레이어 | 친구와 영상 같이 시청하기 |
|-------|-------|-------|
| ![mainPage_app](https://user-images.githubusercontent.com/73422344/154894562-d020a914-b692-4a7d-8c5c-a79c0d897614.gif) | ![videoPlayer_app](https://user-images.githubusercontent.com/73422344/154895222-6398b0d1-1260-43fb-b745-a761f1548f47.gif) | ![watchWithFriend_app](https://user-images.githubusercontent.com/73422344/154895237-485cc0b4-30ff-47e9-b9b4-d3c87327840a.gif) |

| 실시간 스트리밍 생성 | 실시간 스트리밍 시청 | 실시간 채팅 | 상단 고정 채팅 |
|-------|-------|-------|-------|
| ![liveStreamer](https://user-images.githubusercontent.com/73422344/154895854-03033fc1-cd71-4f49-bcba-e86b26af7f2d.gif) | ![liveViewer_app](https://user-images.githubusercontent.com/73422344/154895099-6d134209-8095-4e3c-9b2e-250ec97336eb.gif) | ![liveChatting_app](https://user-images.githubusercontent.com/73422344/154895117-a3b0f2d0-cfa7-49a1-a123-c8683903e24f.gif) | ![pinnedChat_app](https://user-images.githubusercontent.com/73422344/154895131-ea12c663-98b9-468f-b8ff-3d7dc08c5424.gif) |

| 회원가입 | 마이페이지 |
|-------|-------|
| ![register_app](https://user-images.githubusercontent.com/73422344/154894393-91eca694-821d-4e32-9f69-12498d2a5d5c.gif) | ![myPage_app](https://user-images.githubusercontent.com/73422344/154894598-27aa733d-9ff1-401e-b4a4-c8f39e1826b3.gif) | 


## 클라이언트 (frontend)

| 로그인 |
|------|
|![login](https://user-images.githubusercontent.com/35404137/154888253-a110a8fb-cc6f-4cc8-9cb3-43e29044b4d0.gif)|

| 메인페이지 / 비디오 재생 |
|------|
|![main-min](https://user-images.githubusercontent.com/35404137/154888984-e35d9c48-72c5-462c-b6a3-ddd4ba780fc0.gif)|

| 반응형 메인 레이아웃 |
|------|
|![ezgif com-gif-maker (1)](https://user-images.githubusercontent.com/35404137/154892740-42f41d84-3139-495a-be9a-854d3c9b2e20.gif)|

| 회원가입 페이지 | 마이페이지 |
|------|------|
|![register](https://user-images.githubusercontent.com/35404137/154832902-1b754e85-c456-400f-8b2b-4eb089f55c72.gif)|![mypage](https://user-images.githubusercontent.com/35404137/154834050-b219dbf6-6b3c-4bd4-9cb6-9083719368fb.gif)|

| 실시간 스트리밍 생성 | 실시간 스트리밍 시청 |
|------|-------|
|![liveStreaming](https://user-images.githubusercontent.com/35404137/154835797-76d304d5-12bb-4bd6-872d-f532758dac06.gif)|![liveStreamingWatch-min](https://user-images.githubusercontent.com/35404137/154889301-a5227870-e19e-4c0f-8e57-3b2806ccaaf2.gif)|

| 친구와 함께 시청 |
|------|
|![watchWithFriend-min](https://user-images.githubusercontent.com/35404137/154889792-4fcf504f-094d-4f83-8ab3-1d23da1541d0.gif)|

# 기술 스택
## 클라이언트 (iOS)
<img src="https://img.shields.io/badge/-Swift-F05138?&logo=Swift&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-UIkit-2396F3?style=for-the-badge"> <img src="https://img.shields.io/badge/-UIStoryboard-F8CF55?style=for-the-badge"> <img src="https://img.shields.io/badge/-WebRTC-333333?&logo=WebRTC&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-mediasoup ios client-20A6D1?style=for-the-badge"> <img src="https://img.shields.io/badge/-StompClientLib-000000?style=for-the-badge"> <img src="https://img.shields.io/badge/-StarScream-FFE200?style=for-the-badge"> <img src="https://img.shields.io/badge/-Combine-F05138?style=for-the-badge">

## 클라이언트 (frontend)
<img src="https://img.shields.io/badge/-Javascript-F7DF1E?&logo=JavaScript&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-React-61DAFB?&logo=React&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Context API-61DAFB?&logo=React&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-prop types-61DAFB?&logo=React&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Axios-5A29E4?style=for-the-badge"> <img src="https://img.shields.io/badge/-React Qeuery-FF4154?&logo=React Query&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-React Router-CA4245?&logo=ReactRouter&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-styled component-DB7093?&logo=styled-components&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-protoo client-B74244?style=for-the-badge"> <img src="https://img.shields.io/badge/-Stomp-000000?style=for-the-badge"> <img src="https://img.shields.io/badge/-SockJS Client-000000?style=for-the-badge"> <img src="https://img.shields.io/badge/-mediasoup client-20A6D1?style=for-the-badge"> <img src="https://img.shields.io/badge/-Webpack-8DD6F9?&logo=Webpack&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Babel-F9DC3E?&logo=Babel&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Prettier-F7B93E?&logo=Prettier&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-ESLint-4B32C3?&logo=ESLint&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Storybook-FF4785?&logo=Storybook&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-GitHub Actions-2088FF?&logo=GitHub Actions&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Chromatic-FC521F?style=for-the-badge">

## 디자인
<img src="https://img.shields.io/badge/-Figma-F24E1E?&logo=Figma&logoColor=white&style=for-the-badge"> 

## 서버 (api)
<img src="https://img.shields.io/badge/-Srping Boot-6db33f?&logo=Spring Boot&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Spring Security-6DB33F?&logo=SpringSecurity&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Node.js-339933?&logo=Node.js&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Mediasoup-64BAFF?&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-WebSocket-FECC00?&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-SockJS-010101?&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Stomp-010101?&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-MariaDB-003545?&logo=MariaDB&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Redis-DF0000?&logo=Redis&Color=white&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Amazon S3-569A31?&logo=AmazonS3&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-Amazon EC2-FF9900?&logoColor=white&style=for-the-badge"> <img src="https://img.shields.io/badge/-FFmpeg-007808?&logo=FFmpeg&logoColor=white&style=for-the-badge">

## 서버 (infra)
* spring cloud gateway
* Eureka service discovery

# 아키텍처
![image](https://user-images.githubusercontent.com/30483337/154809542-528377b5-569a-4daa-ae51-2e44d38afec6.png)


# ERD
![erd](https://user-images.githubusercontent.com/37957608/153554203-54de8715-6d91-4230-a032-53a05abb1113.png)

# 프로젝트 실행
## 클라이언트 (iOS)
## 클라이언트 (frontend)

1. `src/frontend` 폴더에서 `npm install` 실행
2. `src/frontend` 폴더에서 `.env` 파일 생성 후 아래 내용 복사 후 붙여넣기
```
REACT_APP_API = https://dev.streaminggate.shop

REACT_APP_LIVE_SOCKET = wss://streaminggate.shop:4443

REACT_APP_USER_STATUS_API = http://3.37.201.189:9999

REACT_APP_USER_STATUS_SOCKET = http://3.37.201.189:9999/ws

REACT_APP_CHAT_API = http://3.38.16.211:8888

REACT_APP_CHAT_SOCKET = http://3.38.16.211:8888/ws

REACT_APP_UPLOAD_SERVICE = http://3.39.44.188:50006

REACT_APP_PROFILE_IMAGE = https://sgs-playground.s3.us-east-2.amazonaws.com/profiles/
```
3. `npm run start`로 실행


## 서버 (docker-compose 사용)
**docker-compose 로 서버 실행**
```
$ cd config
$ docker-compose up -d
```
❗ window라면 ffmpeg 설치후 코드 수정필요
- ffmpeg 다운로드: https://ffmpeg.org/download.html
- `src/server/upload-service/src/main/resources/application.yml` 수정:
   `ffmpeg:path`, `ffprobbe:path` 값을 다운로드 받은 실행 파일 위치로 수정

# WebRTC
![webRTC](https://doublems.github.io/assets/postphoto/20210720/img_1.png)
- 웹, 앱(AOS, iOS)에서 별다른 소프트웨어 없이 카메라, 마이크등을 사용한 실시간 커뮤니케이션을 제공하는 기술
- 우리가 알고있는 화상통화, 화상공유등을 구현할수 있는 오픈소스
- JavaScript API로 제공
- P2P 방식 지원

- 장점
    - 짧은 Latency
    - 오픈소스
    - 서버 필요없이 브라우저끼리 통신 가능
- 단점
    - 크로스 브라우징
    - STUN/TURN 서버 필요
    
#### ref.
- [WebRTC](https://gh402.tistory.com/38?category=935378)
---

## Signaling server
![signaling](https://lh6.googleusercontent.com/U7DErjrjC3k0cu2ZZHlTlj9siRtG8Dq6jcbs_O4LxgQkMJugmKfwvuanhkdiJW4LCr29hlkSRK5ZI7GRMBpvzKakxKDQomUgEw58FYIuq-yg_WKJV1Pu094wpDJy1s7KCs5kYqs7)

### STUN
![STUN](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Protocols/webrtc-stun.png)
> 공개 주소를 발견하거나 Peer간의 직접 연결을 막는 등 라우터의 제한을 결정하며 ICE를 보완하는 프로토콜이다.\
> 간단하게 말하면 STUN서버는 해당 Peer의 공인 IP주소를 보내는 역할을 한다.\
> STUN 서버는 두 엔드 포인트 간의 연결을 확인하고 NAT 바인딩을 유지하기 위한 연결 유지 프로토콜로도 사용 가능하다.\
> 하지만 STUN은 항상 효과적이지 않다. 두 단말이 같은 NAT환경에 있을 경우 또는 NAT 보안정책이 엄격하는 등 여러 이유에 따라 STUN이 완벽한 해결책이 되지 않는다.

### TURN
![TURN](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Protocols/webrtc-turn.png)
> STUN의 확장으로 NAT환경에서 릴레이하여 통신을 하게 된다.\
> NAT 보안 정책이 너무 엄격하거나 NAT순회를 하기 위해 필요한 NAT 바인딩을 성공적으로 생산할수 없는 경우에 TURN을 사용한다.\
> TURN서버는 인터넷망에 위치하고 각 Peer(단말)들이 사설망(Private IP)안에서 통신한다. 각 Peer들이 직접 통신하는 것이 아니라 릴레이 역할을 하는 TURN서버를 사용하여 경유한다.\
> 단점은, 클아이언트와의 연결을 거의 항상 제공하지만 STUN에 비해 리소스 낭비가 심하다.\
> ICE Finding Candidate과정에서 local IP로 연결할 수 있는지, Public IP로 연결할 수 있는지 알아낸후 최후의 수단으로 사용해야 한다.

#### ref.
- [STUN/TURN](https://gh402.tistory.com/45?category=935378)


### ICE(Interactive Connectivity Establishment)
>STUN, TURN등으로 찾아낸 '연결가능한 네트워크 주소들'을 Cantidate(후보)라고 한다.\
> ICE라는 프레임워크는 Finding Candidate(후보찾기)를 한다.\
> 보통 3종류 후보들을 갖게 되는데,\
> - [Direct Candidate] Local Address : 클라이언트의 사설 주소(Host Candidate), 랜과 무선랜등 다수 인터페이스가 있으면 모든 주소가 후보
> - [Server Reflexive Cadidate] Server Reflexive Address : NAT장비가 매핑한 클라이언트의 공인망 주소로 STUN에 의해 판단
> - [TURN relay Candidate] Relayed Address : TURN서버가 패킷 릴레이를 위해 할당하는 주소

즉, ICE는 peer끼리 P2P 연결을 가능하게 하도록 '최적 경로'를 찾아주는 프레임워크다.

### SDP(Session Description Protocol)
![SDP](https://media.vlpt.us/images/gojaegaebal/post/a19b9710-b249-494a-aa30-4c6dddc0586f/image.png)
> ICE를 통해 P2P 통신을 할 수 있는 주소 후보들을 찾은후 이를 이용해 정보들을 서로 주고받게 만들어줘야 하는데, 이때 쓰이는 것이 SDP이다.\
> SDP(Session Description Protocol)는 WebRTC에서 스트리밍 미디어의 해상도나 형식, 코덱등의 멀티미디어 컨텐츠의 초기 인수를 설명하기 위한 프로토콜이다.\
> 비디오 해상도, 오디오 전송 또는 수신여부등을 송수신 할 수 있다.\
> SDP는 응답모델(Offer/Answer)을 갖고 있다. A라는 피어가 어떠한 미디어 스트림을 교환하자고 제안을 하면, 상대방으로부터 응답을 기다린다.\
> 상대방이 이에 대해 응한다면, 각자 피어가 수집한 ICE후보중에서 최적의 경로를 결정하고 협상하는 프로세스가 발생하고 수집한 ICE 후보들로 패킷을 보내 가장 지연시간이 적고 안정적인 경로를 찾는다.\
> 최적의 ICE후보가 선택되면 피어간 합의가 완료되어 P2P연결이 설정되고 활성화 된다.

### Trickle ICE
> 일반적으로 각 피어들은 ICE후보들을 수집해서 그 목록을 완성한 후 한꺼번에 교환하게 된다. 하지만 SDP 제안 응답 모델과 맞물리면서 단점으로 작용한다.\
> 한쪽 피어의 ICE후보 수집 작업이 완료되어야만 다른 피어가 ICE 후보를 모을 수 있기 때문에 비효율적이다.\
> 이러한 비효율적인 후보 교환 작업을 '병렬 프로세스'로 수행할수 있게 만드는 것이 바로 Trickle ICE이다.\

즉, Tricle 옵션이 활성화된 ICE 프레임워크는 각 피어에서 ICE후보를 찾아내는 즉시 교환을 시작한다. 

### Signaling server
> 위의 과정들을 시그널링이라고 한다.
> 1. 브라우저가 사용자의 장치에 접근을 한다.
> 2. signaling server를 통해 상대방의 정보를 얻는다.
> 3. Peer to Peer Connection을 통해 통신한다.

#### ref.
- [Signaling Server](https://velog.io/@gojaegaebal/210307-%EA%B0%9C%EB%B0%9C%EC%9D%BC%EC%A7%8090%EC%9D%BC%EC%B0%A8-%EC%A0%95%EA%B8%80-%EB%82%98%EB%A7%8C%EC%9D%98-%EB%AC%B4%EA%B8%B0-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-WebRTC%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%802-ICE-SDP-Signalling)
---

## Media server
WebRTC는 기본적으로 P2P방식으로 동작된다. 그래서 만약 N:M이나 1:N 방식으로 구현하기 위해서는 다음과 같은 구조를 가져아한다.

![WebRTC structure](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2F3ae7X%2FbtqVSuq0WxW%2FOCv3CObABsyKvDQbj0Pjy1%2Fimg.png)

보시다시피 모든 피어간 연결이 필요하기 때문에 네트워크 리소스를 매우 많이 잡아먹고 각 클라이언트에 부담을 많이 주게 된다. 따라서 중간에 중계를 해주는 서버가 하나 필요한데, 이것이 바로 Media server 이다.

Media server 종류
- SFU 방식
- MCU 방식

Media server 오픈소스
- Kurento
- Mediasoup
- Janus


### SFU 방식
![SFU](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fy4uuv%2FbtqVOrWc9nv%2FzXsMk2Mm9SyBDOzXsDbwy0%2Fimg.png)
> SFU 방식은 단순히 받은 데이터를 연결된 피어들에게 뿌려준다. 중간 처리를 하지 않고 그대로 보내주기 때문에 서버에 부하가 적은 편이다.\
> Media server 오픈소스중 Mediasoup가 SFU 방식에 속한다.

### MCU 방식
![MCU](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcJNG3o%2FbtqVTGLy8nf%2FGkoY5kfjWlmRuKSLeGooe1%2Fimg.png)
> MCU 방식은 중아에서 비디오를 인코딩 등과 같은 전처리를 하여 피어에게 다시 전달해주는 역할을 한다.\
> 즉, 중간에서 믹싱을 해준다. 따라서 인코딩을 통해서 압축률을 좋게 하여 각 피어들에게 던져주면 네트워크 리소스 비용에서는 유리하나, 이를 처리하는 server에 CPU 리소스를 많이 잡아먹는 단점이 있다.

#### ref.
- [Mediaserver](https://andonekwon.tistory.com/71)

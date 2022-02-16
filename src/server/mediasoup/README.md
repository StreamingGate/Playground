# Mediasoup server

---
## [WebRTC](https://github.com/StreamingGate/Playground/blob/develop-server/docs/WebRTC.md)


webRTC에 대한 전반적인 설명입니다.

---

## 서비스 소개
WebRTC의 미디어 서버 계열에서 전송방법은 여러가지지만 Mediasoup은 SFU방식으로 전송하고 있습니다.

mediasoup 코어 라이브러리 C++로 이루어져 있고 server를 구성하고 client에서 mediasoup을 이용하기 위한 라이브러리는

Node.js로 구성되어 사용하기 쉬울수 있습니다. 다만 기존의 WebRTC방식과 다르게 sdp/candidate 방식이 아닌 ORTC 기반으로 구성하게 

되어 있어 조금 더 공부가 필요한 프레임워크입니다.

ORTC란
- Object Real-Time Communication에 약자이다. PC나 모바일기기에 추가 프로그램 설치과정 없이도 브라우저에서 실시간 음성대화,\
  화상회의 및 채팅 기능을 만들수 있는 API를 제공합니다.  
- ORTC는 자바스크립트를 통해 구현되고 MS 스카이프, 구글 행아웃등 유명한 실시간 스트리밍에 사용되고 있습니다.  
- 또한 영상처리에 고급 기술인 simulcast와 scalable video coding 기술도 지원하고 있습니다.  
- 지금은 어떻게 됐는지 모르겠지만 MS와 구글이 ORTC를 공동 표준화하려는 이유는 브라우저 상호운용성 확를 위해서라고 합니다.\
  IETF의 SDP와 SDP를 사용하는 통신방식 상태기기에 대한 의존성을 피하기 위해서라고 합니다.
---

## 용어 및 기능 설명
- `RTP` : Real-Time Transport Protocol의 약자로 IETF 표준 프로토콜로 실시간 연결과 데이터 송수신에 필요합니다. WebRTC를 이용해서 데이터 송수신할때 사용합니다.\
  RTP는 데이터 전송 프로토콜로 두 엔드포인트가 현재 상태에서 효율적으로 통신할수 있도록 도와줍니다. 
- `load Device` : 스트리머가 RTP Capabilities를 조회하고 mediasoup-client 라이브러리에서 제공하는 디바이스를 생성하고 디바이스에 RTP Capabilities를 넣어줍니다.
- `Worker` : mediasoup은 worker 라는 개념이 있습니다. worker라는 공간안에 라우터를 생성하고 이 라우터를 통해 데이터를 주고받는 것입니다.\
  mediasoup 공식 docs는 아니지만 개발자에 QnA에 의하면, CPU 코어갯수만큼 worker를 생성하는것이 좋다고 써있으며 이 프로젝트도 CPU의 코어 갯수에 맞춰 
  worker를 생성하고 있습니다. 하나의 worker안에 적당한 라우터 갯수는 공식 docs에는 나와 있지 않습니다. 
- `Router` : 라우터는 보통 우리가 생각하는 '방'이라는 개념으로 생각할수 있습니다. 하나의 라우터에 하나의 방을 생성할 수 있고 통신할수 있습니다.\
  공식 docs에서는 하나의 라우터로 약 400 ~ 600 consumers가 가능하다고 나와있습니다. 이는 즉, one2many에서 약 `200~300명`이 시청 가능하다는 이야기가 됩니다.\
  1인당 오디오와 비디오 2개의 데이터를 consume하기에 400~600/2로 대략적으로 계산할수 있습니다.
- `Protoo` : Mediasoup 공식 사이트에서는 Protoo라는 라이브러리도 같이 제공하고 있습니다.\
   Protoo내부를 살펴보면 WebSocket으로 구성되어 있습니다. Mediasoup + WebSocket으로도 구현할수 있지만 Protoo 라이브러리를 사용하면 좀 더 편하게 Mediasoup을 이용하여 구현할수 있습니다.  
- `Room` : Protoo 라이브러리에서 제공하는 기능입니다. 실제로 데이터를 보내고 각 방으로 격리시키는것은 라우터이지만 `방`이라는 개념을 쉽게 사용할수 있도록 제공 해줍니다.  
---

## 핵심 포인트
- `Worker` : worker를 생성하기 위해 우선 server를 올리는 인스턴스의 cpu core 갯수를 가져왔습니다. 그리고 core 갯수만큼 for문을 돌며  
worker를 생성했습니다.
- `Router` : 라우터를 생성하기 위해서는 하나의 worker를 가져와야 하는데 worker를 사용할때마다 인덱스를 증가시키면서 단순하게 가져온다면\
  하나의 worker에만 라우터가 쏠리는 현상이 발생할 수 있습니다.\
  때문에 `load Balancing`을 생각하여 Map 함수와 배열을 이용하여 worker에게 고유 id를 부여하고 이를 worker가 사용될때마다 갯수를 카운트하고 카운트 갯수 기준으로 배열을 정렬하여 최소로 사용된 worker를 가져오는 로직으로 구성해 놨습니다.  
- `PipeToRouter (추후 업데이트 예정)` : 위에서 언급했다시피, one2many 상황에서는 하나의 라우터로 약 200~300명이 한계이지만 Mediasoup에서\
  PipeToRouter라는 메소드를 제공하고 있습니다. 이는 하나의 라우터를 또 다른 라우터에 연결하여 인원수를 늘리는 방법입니다. 
  



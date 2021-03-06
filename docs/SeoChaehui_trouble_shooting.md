## 클라이언트(iOS)
*  mediasoup과 iOS 연결
    * 문제
        1. mediasoup에서 공식적으로 제공하는 iOS Client 라이브러리의 부재
        2. iOS를 위한 써드파티 라이브러리 및 예시가 하나 존재하였으나, 본 프로젝트에서 사용할 서버와 내부 동작에 맞지 않아서 그대로 사용하기 무리가 있었음
    * 해결
        1. 본 프로젝트에서 사용하는 protoo 서버와 iOS 클라이언트가 통신할 수 있도록 header 추가
        2. 웹/서버 개발자분들과 함께 mediasoup 내부를 들여다보며 동작 프로세스 순서를 하나하나 확인하고, 이를 반영하여서 iOS 라이브러리 적용 예시를 수정하여서 우리에게 필요한 동작을 알맞는 순서로 수행하도록 함.
        2. 1:1 방식으로 제작된 적용 예시를 1:N에 적용할 수 있도록 변수를 수정하고, 불필요한 함수를 삭제함
* 소형 비디오/라이브 플레이어
    * 문제
        1. 소형 플레이어가 제스처를 통해 전환되도록 하여야 하고, 모든 탭바를 아우르게 동작해야(재생이 끊기지 않아야) 하는데, 기본으로 제공되는 UITabBarController에서는 이를 구현하기 어려움이 있음
            1.  플레이어가 소형화되지 전에는 탭바보다 z축으로 위에, 소형화 된 후에는 탭바보다 z축으로 아래에 위치해야 함. 이를 UITabBarController로 구현했을 때, 보이는 UI는 온전하여도 탭바에 클릭 액션이 발생하지 않음
            2.  UITabBarController에 플레이어를 SubView로 삽입할 경우, safeArea가 제대로 반영되지 않는 이슈가 발생하여서 따로 처리를 해줘야 함
    * 해결
        1. 탭바를 직접 커스텀해서 제작함
        2. 초기(v.1) 커스텀 탭바는 하나의 containerView에 각 탭에 해당하는 UINavigationController로 변경하여서 뷰를 쌓는 방식을 채택함. 이 경우, 탭바 바뀌었다가 돌아가면 이전에 쌓였던 뷰가 보존되지 않고 날라가는 이슈가 발생함. 쌓인 뷰가 유지되는 탭바의 특성을 살리고자, 각 탭에 해당하는 containerView를 만들고, 이 containerView를 보이게 하거나 뷰를 쌓고 없애는 식(v.2)으로 탭 구조를 구현함

| 기본 제공 UITabBarController | 커스텀 탭바 컨트롤러 v.1 | 커스텀 탭바 컨트롤러 v.2 |
|-------|-------|-------|
| ![defaultTabBar](https://user-images.githubusercontent.com/73422344/154917864-8e2b89cb-3f63-47da-876b-e8b3d33f9f50.png) | ![customTabBar(v1)](https://user-images.githubusercontent.com/73422344/154919366-b873e8df-50d7-49e2-abef-6332ef1158ce.png) | ![customTabBar(ㅍ2)](https://user-images.githubusercontent.com/73422344/154919132-5e2730fc-765c-4077-a979-2cce9019d3a8.png) |

* 비정상적 종료 대비
    * 문제
        1. 온/오프라인 상태나 실시간 채팅의 경우, disconnect 시 헤더를 넣어줘야 정상적으로 disconnect가 실행됨. 만약, 비정상적인 종료(ex. 앱 강제 종료)로 헤더 없이 disconnect될 경우, 유저의 상태가 제대로 반영되지 않는 이슈 발생
    * 해결
        1. 앱 LifeCycle이 disconnect 상태가 되었을 때, 실시간 채팅 소켓을 disconnect하도록 하여서 실시간 채팅방에서 나가도록 함
        2. 앱 LifeCycle이 background 상태가 되었을 때, 상태 관리 소켓을 disconnect하여서 유저의 상태가 오프라인으로 표시되도록 함
        3. 앱 LifeCycle이 active 상태가 되었을 때, 상태 관리 소켓을 connect하여서 유저의 상태가 온라인으로 표시되도록 하고, 해당 유저의 친구들의 최신 정보를 가져오도록 함.
* SFSafariViewController 접근 이슈
    * 문제
        1. 실시간 스트리밍 생성의 경우, SFSafariViewController를 이용해서 웹뷰로 방을 생성하고 있었는데, 이 경우 웹뷰에서 발생하는 이벤트를 앱이 알 수 없어서 방 종료 시점을 모르는 문제 발생
        2. 방송 송출은 웹뷰로 하지만, 실시간 채팅은 네이티브로 하였기 때문에 방송 종료 시점에 앱에서 실시간 채팅방을 닫아야 했고, 그렇기에 방 종료 시점에 대한 노티피케이션이 필요했음.
    * 해결
        1. 앱 프로젝트에 URLScheme 심고, 방 종료 버튼을 눌렀을 때 해당 URLScheme이 트리거 되도록 함
        2. URLScheme이 트리거 되었을 때, 앱에서 이를 인지하고 실시간 채팅 종료를 요청하여서 정상적으로 방송과 채팅 모두가 종료되도록 함.

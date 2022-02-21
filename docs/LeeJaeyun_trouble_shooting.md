## 클라이언트(frontend)

* 인풋 컴포넌트 유효성 검사 로직 <br/>
  https://github.com/StreamingGate/Playground/blob/develop-frontend/src/frontend/src/utils/hook/useForm.js#L23

  * 문제  
    인풋 제어 커스텀 훅과 `yup` 라이브러리를 이용한 유효성 검증 과정에서, 한번도 포커싱이 발생하지 않거나, 입력한적이 없는 인풋 컴포넌트도 에러 메세지가 나타나는 문제가 발생
  * 해결
    1. 인자로 넘어오는 인풋 필드 마다 `touched` 객체를 지정해 인풋 컴포넌트에 `onBlur`이벤트가 호출될 때 해당 필드의 touched 값을 `true`로 변환
    2. 유효성 검사를 진행할 때, `touched` 값이 `true`인 필드만 로직이 동작해 에러 메세지를 보여주게끔 설계

* 모바일 실시간 스트리밍 진행 화면 웹뷰 카메라 전환 <br/>
  https://github.com/StreamingGate/Playground/blob/develop-frontend/src/frontend/src/utils/hook/useStreamMedia.js#L121

  * 문제  
    모바일 웹뷰에서 `applyConstraints`를 이용해 전/후면 카메라 전환을 시도 했지만 `Media Stream` 이 변경되지 않는 문제가 발생
  * 해결
    1. `Media Stream`과 `Media Stream`의 설정을 `react`의 `state`로 관리해 전/후면 같은 `Media Stream`설정이 변경 될 때 마다 `useState` 함수로 `Media Stream`을 재설정해 새로운 `Media Stream`이 화면에 적용되게끔 설계

* 인피니트 스크롤 <br/>
  https://github.com/StreamingGate/Playground/blob/develop-frontend/src/frontend/src/utils/hook/useInfinitScroll.js#L8

  https://github.com/StreamingGate/Playground/blob/develop-frontend/src/frontend/src/pages/Home/HomePage/HomePage.jsx#L31

  * 문제  

    인피니트 스크롤을 구현하기 위해 `window`에 scroll 이벤트를 등록할 경우 이벤트가 빈번히 발생하게됨. 이를 방지하기 위해서는 이벤트 `throttle`을 구현하거나 라이브러리를 사용해 잦은 이벤트 발생을 막아야 함

  * 해결
    1. `IntersectionObserver`를 `custom hook`으로 만들어 다음 데이터를 호출할 위치 정보를 가지고 있는 `observer`객체를 export 함
    2. 인피니트 스크롤을 적용하고자 하는 페이지에서 `observer`객체를 호출하고, 기준 컴포넌트에 닿았을때 호출할 `API`메소드를 콜백함수로 전달해 사용

* 컴포넌트 문서화 <br/>
  https://www.chromatic.com/builds?appId=61d257a71897c4003a50a451

  https://github.com/StreamingGate/Playground/blob/develop-frontend/.github/workflows/chromatic.yml#L1

  * 문제  
    컴포넌트 문서화를 통해 재사용성을 높이고, 결과물에 대해 팀원들에게 피드백을 받을 방법을 고민

  * 해결

    1. Storybook을 통해 구현한 컴포넌트를 문서화 하고 github action을 통해 `develop-frontend-ui`브랜치에 머지 되었을때 자동 배포 되게끔 설계

    2. Storybook 배포 자동화 `yaml`파일에 슬랙 `action`을 연결하여 배포완료 되었을 경우 주소를 슬랙 메세지로 보내 피드백을 받을 수 있게 함 

       ![image](https://user-images.githubusercontent.com/35404137/154907083-6fdfcb9c-dd7e-4a6a-9534-eeddda063b19.png)

* protoo-client 오픈소스 분석 <br/>
  https://github.com/versatica/protoo/blob/master/client/lib/Message.js#L108
  https://github.com/versatica/protoo/blob/master/client/lib/Message.js#L148
  * 문제  
    미디어 서버와 통신하기 위해 `protoo-client`라는 웹소켓 라이브러리를 사용하기로 했지만 iOS에는 `protoo-server`와 통신을 하기위한 별도의 client 라이브러리가 존재하지 않아 통신을 할 수 있는 방법을 고민해야 했음
  * 해결
    1. `protoo`를 깃헙 코드를 열어 확인해 보니 순수 websocket을 이용하여 docs에 정의되어 있는 메소드들이 구현되어 있음을 확인
    2. iOS 역시 순수 websocket을 이용한 라이브러리를 이용하고 있어, `protoo-client` 와 `protoo-server`사이의 메세지 전송 형식을 맞춰주면 통신을 할 수 있을 거라 생각함
    3. `protoo-client`깃헙 코드에서 메세지 전송 `json` 형식을 찾은 후, iOS에 적용하여 통신 성공

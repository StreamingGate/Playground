# 이우재 트러블 슈팅

## Mediasoup 관련 이슈

### Https 이슈
처음 로컬에서 실행할때는 인증서 관련 이슈가 없었습니다. 로컬에서 돌리다보니 자기 자신이 방송을 하는것이기에 문제가 없었으나,

로컬에서만 테스트하고 프로젝트를 진행한다면 프로젝트 특성과 맞지 않다고 판단했습니다. 때문에 EC2에 올려 테스트를 해본 결과

브라우저 단에서 https가 아니면 웹캠과 마이크를 차단하는 경우가 발생하였습니다. 이러한 이슈를 해결하기 위해 도메인을 구입한다음

인증서를 무료로 만들어주는 letsencrypt라는 무료 CA입니다.

```Let’s Encrypt란?```\
Let’s Encrypt는 SSL 인증서를 무료로 발급해주는 CA(Certificate Authorities)입니다. 여러 글로벌 기업의 후원을 받고 있으며

모질라(Mozilla) 재단에서 ‘신뢰할 수 있는 인증 기관(Trusted CA)'으로 인증도 받았습니다. 따라서 베리사인(VeriSign)이나 코모도(Comodo)와 같은 유명 인증 업체와 같은 신뢰도를 가지며

SSL 암호화 기술 방식과 동작도 정확히 동일합니다.

단지 다른 것은 사이트의 인증에 문제가 있어 최종 웹사이트 방문자가 피해를 입었을 경우 배상 여부만 차이가 있을 뿐입니다.

letsencrypt를 이용하여 인증서를 발급받고 nginx를 이용하여 https로 들어오는 요청을 http 내부 서버로 리다이렉트 해주는 방식을 사용 하였습니다.

물론 nginx를 쓰는 방법 말고 다양한 방법이 있습니다. aws에서 제공하는 router53과 ELB를 사용하여 해결할수 있습니다만, 비용이 부과되고 빠른 시간내에 구현하기에는

무리가 있다고 판단하였습니다.

값싼 도메인을 구입하여 무료 CA를 이용하여 인증서를 발급 받은후 이를 nginx를 통해 해결하였습니다. 

### 워커 이슈
```이슈 : ``` 
mediasoup은 워커란 개념이 존재합니다. 하나의 워커안에 여러개의 라우터를 둘수 있고 서로 화상 채팅하는 방 하나당 라우터 하나라고 볼수 있습니다.

한마디로 라우터는 하나의 '방' 개념으로 볼수 있습니다. mediasoup 공식 docs에서는 인스턴스에 CPU 코어수에 맞게 워커를 생성하길 권장하고 있습니다.

때문에 이를 해결하기 위해서 cpu 코어수를 우선 카운터 한후 반복문을 돌며 워커를 생성했습니다. 하지만 여기서도 이슈는 발생합니다.

한 워커내에 라우터가 몰릴수 있는 상황이 있습니다. 이러면 성능 저하와 리소스를 제대로 다루지 못하는 상황이 발생합니다.

```해결방법 : ``` 
hash map과 객체를 담은 배열을 선언했습니다. 우선 반복문을 돌며 각 라우터에 고유 id를 부여하였고 이를 key-value형태로 hash map에 저장하였습니다.

그다음 워커를 사용할때마다 배열에 { "라우터 id" : {value} , "cnt" : {숫자} }  이러한 형식으로 저장하여 각 워커가 몇번 사용됐는지 카운터를 한후 배열을 정렬하여 가장 앞에 있는 라우터 id를

가져오는 방법을 사용했습니다. 물론 정렬 알고리즘을 쓰기에 시간복잡도와 hash map, 배열 두가지를 사용하기에 공간복잡도도 늘어났지만 이는 CPU 코어 개수에 의해 정해지기에 크게 지장이 없을거라

판단하였습니다.

### 라우터 이슈
```이슈 : ```
mediasoup에서 하나의 라우터는 one2many 상황에서는 약 250명정도 수용할수 있다고 나와있습니다. 이를 넘는다면 터질수 있다고 공식 docs에 써있습니다.

하지만 playground 프로젝트는 유튜브나 트위치같이 실시간 방송을 시청하는 서비스이기에 250명은 부족하다고 판단하였고 이를 해결책을 찾아보았습니다.

```해결방법 : ```
다행히 mediasoup에서 pipeToRouter라는 메소드를 제공하여 각 라우터끼리 연결을 할수 있었습니다. 1번 라우터와 2번라우터가 있고 이를 연결해놓았다면,

1번라우터에서 방송 하는것을 2번 라우터에 접속한 사람이 똑같이 시청할수 있습니다.

하지만 그냥 쉽게 연결이 되지는 않았습니다. 1번 라우터에서 방송하는 사람의 id가 필요하고 1번 라우터의 transport, 라우터등 많은 정보가 필요했습니다.

심지어 1번 라우터 안에 시청자 수가 약 230~250명이 되었는지 체크를 한다음 라우터를 새로 생성한다음 연결해야 했기에 쉽지는 않았습니다.

우선 워커 이슈를 해결했던 방법처럼 라우터 이름으로 key값을 하고 해당 라우터에 참여자의 수를 value로 하여 값을 체크하다가 만약 230명정도 넘는다면

새로운 라우터를 생성하고 기존의 참가하려던 라우터의 정보를 가져와 새로운 라우터에 정보를 입력하는 방식을 사용하여 해결하였습니다.

## JWT 토큰 이슈
```이슈 : ```
처음 토큰을 인증못하는 이슈가 있었습니다. 이유는 bind해주는 라이브러리를 설치 하지 않았었습니다.

그 다음으로 토큰을 생성할때 string 형식으로 "token_secret" 형식으로 생성하였는데 이는 잘못된 방식이 였습니다.

```해결방법 : ```
우선 첫번째 이슈 해결방법은 bind 라이브러리를 설치하며 쉽게 해결하였습니다.

두번째 이슈는 String secretKey = Base64.getEncoder().encodeToString("token_secret".getBytes()) 형식으로

생성하였습니다. 또한 토큰을 체크할때는 Jwts.parser().setSigningKey("token_secret".getBytes()) 으로 해서

해결하였습니다.

## 프로필 사진 등록 이슈
```이슈 : ```
프로필 사진을 저장할때 form-data 형식으로 저장하는 방식을 하고 싶지 않았습니다. 보안상의 이슈도 있고 인스턴스에 저장할때와 삭제할때

모두 신경써줘야 했기에 다른 방법을 찾아보았습니다.

```해결 방법 : ```
이미지를 BASE64형태로 받는 방법을 알아 냈습니다. 또한 웹,앱 둘다 BASE64형식으로 이미지 파일을 보내는것이 더 편하다고 하여 이 방식을 채택했습니다.

base64로 들어온 String을 InputStream으로 decoding하고 이를 S3에 올리는 작업을 해야 합니다. 다행히 amazon S3에서 제공해주는 SDK에 InputStream을 이미지로 저장시켜주는 메소드가 있습니다.

우선, base64 String을 String data라 칭하겠습니다.

byte[] bytes = Base64.getDecoder().decode(data);\
-String으로 들어온 base64를 byte형식의 array에 decoding하여 저장합니다.

InputStream inputStream = new ByteArrayInputStream(bytes);\
-이를 InputStream으로 만들어줍니다.

ObjectMetadata metadata = new ObjectMetadata();

metadata.setContentLength(bytes.length);

metadata.setContentType("image/png");

metadata.setCacheControl("public, max-age=31536000");\
-InputStream에는 이미지에 대한 메타데이터가 없습니다. 때문에 메타데이터를 생성해서 주입해줍니다.

amazonS3.putObject(new PutObjectRequest(bucket, dirName+reName, inputStream, metadata)\
.withCannedAcl(CannedAccessControlList.PublicRead));\
-마지막으로 aws S3에 올려주는 코드입니다.

PutObjectRequest(버켓이름,파일이름,inputStream, 메타데이터).withCannedAcl는 접근권한 설정입니다.
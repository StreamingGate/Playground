# upload-service
일반 영상을 업로드하기 위한 API입니다.

# 사용 기술
* Spring boot 2.6
* MariaDB
* FFMPEG
* AWS S3

# API
* 일반 영상 업로드
* 라이브 종료 후 영상 업로드

# 서버 실행시 필요한 yml
추가 위치: `resources/`  
application-s3.yml
```yaml
cloud:
  aws:
    stack:
      auto: false
    region:
      static: ap-northeast-2
    credentials:
      access-key: {dummy}
      secret-key: {dummy}
    s3:
      image:
        bucket: sg.playground
        input-dir: video/input
        output-dir: video/output
        domain: https://s3.ap-northeast-2.amazonaws.com
        result-prefix: ${cloud.aws.s3.image.domain}/${cloud.aws.s3.image.bucket}/${cloud.aws.s3.image.output-dir}
logging:
  level:
    com:
      amazonaws:
        util:
          EC2MetadataUtils: error
```
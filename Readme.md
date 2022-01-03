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

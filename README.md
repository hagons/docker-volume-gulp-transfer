# 라라벨 기본 환경구성

## 1. 필수 환경 설정

- [docker](https://www.docker.com/) 설치

  - 도커 환경 설정 : `Resources - FILE SHARING` 에서 + 아이콘으로 소스코드가 있는 전체 드라이브를 추가.
  - 도커 서버 CPU, RAM 구성은 여유 상황에 맞게 수정.

- [git](https://git-scm.com/) 설치

- `.env` 파일 (팀즈 채팅방)
  - `.env` 파일을 `qtum_funding/src` 폴더에 이동.

- 소스 코드 다운로드 (https://git.coinvest.kr/coehdus/quantum.git)

## 2. 실행

1. 소스 파일 다운로드 및 이동

```sh
cd qtum_funding
git clone https://git.coinvest.kr/coehdus/quantum.git
```

2. 컴파일

서버를 구성할 때 최초 한번만 입력. 약 30분 소요.  
composer 에서 네트워크 부분에서 속도 걸리는 것 같음.

```sh
docker-compose build
```

3. 서버 실행

최초에 vendor 설치로 시간 소요됨. 약 10분 소요.  
진행 상황은 로그를 통해서 확인 가능.

```sh
docker-compose up -d
docker logs -f qtum_funding_src_1
```

4. CLI 접근

```sh
docker exec -it qtum_funding_src_1 bash
php artisan
```

도커 내부에 리눅스에 루트 권한으로 접근한다.  
`qtum_funding_src_1`는 도커 컨테이너의 이름.

5. 도커 실행 로그, 아파치 로그

```sh
docker logs -f qtum_funding_src_1
```

`qtum_funding_src_1`는 도커 컨테이너의 이름.

6. 서버 종료

재부팅 때도 자동으로 켜지므로, 다른 프로젝트로 넘어갈 때 사용.

```sh
docker-compose down
```

7. 가상환경 데이터 삭제

```sh
docker system prune
```

## 3. 서버 정보

- http://localhost:80/
- php : 7.3.0
- 아파치 서버 버전 : 2.4.25 (Debian)
- 라라벨 버전 : 6.18.14
- 컴포저 버전 : 1.10.6 (도커 실행 시점의 최신버전)
- npm 버전 : 6.14.4 (도커 실행 시점의 최신버전)
- node 버전 : 14.2.0 (도커 실행 시점의 최신버전)
- 지원 브라우저 범위 : 미정

## 4. 디버거

- xdebug port 9001

## 5. 기타 사항

dockerfile 에서 데비안 계열 서버에서 설치 종속성 내용 확인 가능.  
80, 9001 포트 사용.  
내부 로컬 호스트 IP (192.168.0.X) 사용.

## 6. vscode 설정

1. 환경변수 설정

- [php](https://www.php.net/downloads.php) 다운로드.
- Ctrl + Shift + P
- open settings 입력
```json
{
  "php.validate.executablePath": "C:\\php-7.4.1-Win32-vc15-x64\\php.exe",
  "php.executablePath": "C:\\php-7.4.1-Win32-vc15-x64\\php.exe"
}
// 다운로드한 php 실행 파일의 경로
// vscode 의 lint 등을 위한 php 이므로 서버와 동일 버전을 맞출 필요 없음.
```

2. 확장 추천

- Ctrl + Shift + X
- 다음 확장 검색 후 설치.
  - Laravel Extension Pack (라라벨 관련 하이라이트 등)
  - VSCode Browser Sync (저장 시 브라우저 자동 새로고침)

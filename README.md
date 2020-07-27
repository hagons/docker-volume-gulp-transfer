# 라라벨 로컬 환경 구성 가이드

## 1. 필수 환경 설정

- [docker](https://www.docker.com/) 설치

- [git](https://git-scm.com/) 설치

- 소스 코드 다운로드 (`.env` 파일)

## 2. 실행

- 컴파일

서버를 구성할 때 최초 한번만 입력.

```sh
docker-compose build
```

- 서버 실행

```sh
docker-compose up -d
docker logs -f <YOUR_INSTANCE_NAME>
```

- CLI 접근

```sh
docker exec -it <YOUR_INSTANCE_NAME> bash
php artisan
```

- 도커 실행 로그, 아파치 로그

```sh
docker logs -f <YOUR_INSTANCE_NAME>
```

- 서버 종료

재부팅 때도 자동으로 켜지므로, 다른 프로젝트로 넘어갈 때 사용.

```sh
docker-compose down
```

- 가상환경 데이터 삭제

```sh
docker system prune --volumes
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
- xdebug port 9001


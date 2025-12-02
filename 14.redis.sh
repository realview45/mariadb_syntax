# window에서는 redis가 직접설치가 안됨 -> 도커를 통한 redis 설치
docker run --name my-redis-container -d -p 6379:6379


# redis 접속명령어
redis-cli

# docer에 설치된 redis 접속명령어
docker exec -it 컨테이너ID(docker ps로 찾기) redis-cli
exit

# redis는 0~15번까지의 db로 구성(default는 0번)
# db번호 선택
select db번호

# db내 모든 키값 조회(많이 씀)
keys *

# String자료구조
# set key:value 형식으로 값 세팅 중복 시 덮어쓰기 된다.
set user:email:1 hong@naver.com
set user:email:2 hong2@naver.com
# 이미존재하는 key를 set하면 덮어쓰기된다.
set user:email:2 hong2@naver.com
# key값이 이미 존재하면 pass시키고 없을 때만 set하기 위해서는 nx옵션 사용
set user:email:1 hong3@naver.com nx
# 만료시간(ttl: time to live) 설정은 ex옵션사용(초단위)
set user:email:2 hong2@naver.com ex 30
# get key를 통해 value값 구함
get user:email:1
# 특정 key값 삭제
del 키값
# 현재 DB내 모든 key값 삭제
flushdb

# redis String 자료구조 실전활용
# 사례1 : 좋아요기능구현 -> 동시성이슈 해결
set likes:posting:1 0 #redis는 기본적으로 모든 key:value가 문자열. 그래서 0으로 세팅해도 내부적으로 "0"으로 저장
incr likes:posting:1 #특정key값의 value를 1만큼 증가
decr likes:posting:1 #특정key값의 value를 1만큼 감소

# 사례2 : 재고관리 -> 동시성이슈 해결
set stock:product:1 100
incr stock:product:1
decr stock:product:1

# 사례3 : 로그인 성공시 토큰 저장 -> 빠른 성능
set user:1:refresh_token abcdexxxxx ex 1800

# 사례4 : 데이터 캐싱 -> 빠른 성능(중요)
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000

# list자료구조
# redis의 list는 deque와 같은 자료구조. 즉, double-ended-queue 구조
lpush students kim1
lpush students lee1
rpush students park1
# list조회
lrange students 0 2 #0번째부터 2번째까지
lrange students 0 -1 #0부터 끝까지
lrange students 0 0 #0번째 값만 조회
lrange students -2 -1 #마지막에서 두번째값 까지 조회
# list값 꺼내기(꺼내면서 삭제)
rpop students
lpop students
# A리스트에서 rpop하여 B리스트에 lpush(중요X 잘 안쓰는 문법)
rpoplpush A리스트 B리스트
rpoplpush students students
# list의 데이터 개수 조회
llen students
# expire, ttl 문법 모두 사용가능
#redis LIST 자료구조 실전활용
# 사례1 : 최근조회한 상품목록
rpush user:1:recent:product apple
rpush user:1:recent:product banana
rpush user:1:recent:product orange
rpush user:1:recent:product melon
rpush user:1:recent:product mango
# 최근본상품목록3개조회
lrange user:1:recent:product -3 -1 

# set자료구조 : 중복없음, 순서없음.
sadd memberlist m1
sadd memberlist m2
sadd memberlist m3
sadd memberlist m3
# set조회
smembers memberlist
# set의 멤버개수 조회
scard memberlist
#redis SET 자료구조 실전활용
# 사례1: 좋아요 구현
# 게시글상세보기에 들어가면
scard likes:posting:1 #좋아요 개수
sismember likes:posting:1 abc@naver.com #내가 좋아요를 눌렀는지 안눌렀는지
sadd likes:posting:1 abc@naver.com # 좋아요를 누른 경우
srem likes:posting:1 abc@naver.com # 좋아요 취소

sadd likes:posting:1 bcd@naver.com
sadd likes:posting:1 abc@naver.com
scard likes:posting:1

# zset자료구조 : sorted set
# zset활용 사례1 : 최근본상품목록
# zset도 set이므로 같은 상품을 add할 경우에 중복이 제거되고, score(시간)값만 업데이트
zadd user:1:recent:product 151400 apple
zadd user:1:recent:product 151401 banana
zadd user:1:recent:product 151402 orange
zadd user:1:recent:product 151403 melon
zadd user:1:recent:product 151404 mango
zadd user:1:recent:product 151405 melon #0반환
# zset조회 : zrange(score기준 오름차순 정렬), zrevrange(내림차순 정렬)
zrange user:1:recent:product -3 -1
zrevrange user:1:recent:product 0 2 withscores


# hashes자료구조 : value가 map형태의 자료구조 (key:value, key:value, ... 형태의 구조)
# set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000 (String)과의 비교
hset member:info:1 name hong email hong@daum.net age 30 #3 반환 덮어쓰기시 0

#특정값 조회
hget member:info:1 name
#특정값 수정
hset member:info:1 name hong2
# 빈번하게 변경되는 객체값을 저장시에는 hashes가 성능 효율적

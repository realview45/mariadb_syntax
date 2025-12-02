--tinyint : 1바이트 사용. -128~127까지의 정수표현 가능.(unsigned 0~255)
--author테이블에 age컬럼 추가
alter table author add column age tinyint unsigned;
insert into author(id, name, email, age) values(6, '홍길동', 'aa@naver.com', 300);

--int : 4바이트 사용. 대략 40억 숫자범위 표현 가능. -20억 ~ 20억

--bigint : 8바이트 사용. 
select * from information_schema.key_column_usage where table_name='posts';--제약조건 조회
alter table post drop foreign key post_ibfk_1;--나중에 배움 post_ibfk_1제약조건 삭제

--author, post테이블의 id값을 bigint로 변경(제약조건 삭제)
alter table post modify column id bigint;
alter table post modify column author_id bigint;
alter table author modify column id bigint;

--decimal(총자리수, 소수부자리수) (float,double 안씀)
alter table author add column height decimal(4,1);
--정상적으로 insert
insert into author(id, name, email, height) values (7,'홍길동', 'ab@naver.com',162.2); 
--잘리도록 insert
insert into author(id, name, email, height) values (8,'홍','abc@naver.com',1622.22);

--문자타입 : 고정길이(char), 가변길이(varchar, text)
alter table author add column id_number char(16);--길이
alter table author add column self_introduction text;

--blob(바이너리데이터) 실습
--일반적으로 blob으로 저장하기 보다는, 이미지를 별도로 저장하고, 이미지경로를 varchar로 저장한다.
alter table author add column profile_image longblob;                                 --안중요
insert into author(id, name, email, profile_image) values(9, "ssss","sssss@naver.com", LOAD_FILE('C:\\고양이.jpg'));

--enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
--role 컬럼 추가
alter table author add column role enum('admin', 'user') not null default 'user';
--not null시 맨 앞의 값 가져옴
--admin, user, null 3가지만 들어올수있음

--enum에서 지정된 role을 insert
insert into author (id,name,email,role) values(10,'jk','jk@naver.com','admin');
--enum에서 지정되지 않은 값을 insert->error 발생 truncated
insert into author (id,name,email,role) values(11,'jk2','jk2@naver.com','super-admin');

--role을 지정하지 않고 insert
insert into author (id,name,email,role) values(13,'jk2','jk2@naver.com');

--date(연월일)와 datetime(연월일시분초)
--날짜타입의 입력, 수정, 조회시에는 문자열 형식을 사용
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post (id, title, contents, author_id, created_time) values (4,'hello4', 'hello4world',3,'2019-01-01 14:00:30');
--datetime과 default 현재시간 입력은 많이 사용되는 패턴           현재시간을 자동으로 찍어내는 함수
alter table post modify column created_time datetime default current_timestamp();
insert into post (id, title, contents, author_id) values (5,'hello5', 'hello5world',3);

--비교연산자
select * from author where id>=2 and id<=4;
select * from author where id in (2,3,4); 
select * from post where author_id in (select )서브쿼리

select * from author where id between 2 and 4; -- 2, 3, 4

--like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like "h%";시작하는
select * from post where title like "%h";끝나는
select * from post where title like "%h%";둘다

--regexp : 정규표현식을 활용한 조회
select * from author where name regexp '[a-z]'; --이름에 소문자알파벳이 포함된 경우
select * from author where name regexp '[가-힣]'; --이름에 소문자알파벳이 포함된 경우

--타입변환 - cast
--문자 -> 숫자
select cast('01' as unsigned); --1
--숫자 -> 날짜
select cast(20251121 as date); --2025-11-21
--문자 -> 날짜
select cast('20251121' as date); --2025-11-21


--날짜타입변환 - date_format(Y, m, d, H, i, s)
select created_time from post;
select date_format(created_time, '%Y-%m-%d') from post;
select date_format(created_time, '%H-%i-%s') from post;

select date_format(created_time, '%Y')=2025 from post;

select * from post where date_format(created_time, '%Y')='2025';--2025년 데이터만 조회
select * from post where date_format(created_time, '%m')='01';--01월 데이터만조회
select * from post where cast(date_format(created_time, '%m') as unsigned) = 1;

--실습 : 2025년 11월에 등록된 게시글 조회         
select * from post where date_format(created_time, '%Y-%m') = '2025-11';
select * from post where created_time like '2025-11%';

--실습 : 2025년 11월1일부터 11월19일까지의 데이터를 조회 시분초 때문에
select * from post where created_time >= '2025-11-01' and created_time < '2025-11-20';


--요약
숫자(정수 tinyint, int, bigint, 실수 decimal고정소수점(오차발생X) float, double(부동소수점)(오차발생))
문자(char(고정길이 빈공간 공백 정해진 길이 상징성 varchar를 써도 상관없음 주민번호 전화번호 성별), 
    varchar(가변길이 공간효율적 메모리기반 저장 성능좋음), text(가변길이 디스크기반 저장 공간효율적))

enum 원하는 데이터 종류의 타입을 지정한다. 없는 값을 집어 넣는 것은 불가
date(연월일), datetime(연월일시분초)
IS NULL, IS NOT NULL 만 사용
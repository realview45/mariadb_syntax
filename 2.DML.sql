-- insert: 테이블에 데이터 삽입 잘 안씀 UI에서 작업 insert into values 외우기
insert into 테이블명(컬럼1, 컬럼2, 컬럼3) values(데이터1, 데이터2, 데이터3);

-- 문자열은 일반적으로 작은따옴표 사용
insert into author(id, name, email) values(4, 'hong4', 'hong4@naver.com');

--update : 테이블에 데이터를 변경 여러개 변경이 흔함 id빼먹으면 큰일남 다 바뀜 update set where
update author set name='홍길동', email='hong100@naver.com' where id=3;

--delete : 삭제 컬럼명시가 없다. 수정에서 가능하기 때문에 delete from where
delete from 테이블명 where 조건;
delete from author where id=4;

--select : 조회 많이 씀 열조회 select from
select 컬럼1, 컬럼2 from 테이블명;
select name, email from author;
select * from author;
--*모든 컬럼을 의미 where가빠지면 모든 데이터

--select 조건절(where) 활용 행조회
select * from author where id =1;
select * from author where name ='홍길동';
select * from author where id >2 and name='홍길동';
select * from author where id in (1,3,5);--에러 안남

--이름 홍길동인 글쓴이가 쓴 글 목록을 조회하시오
select * from post where author_id in(select id from author where name='홍길동'); 

--중복 제거 조회 : distinct
select name from author;
select distinct name from author;

--정렬 : order by + 컬럼명 외우기
--asc : 오름차순 desc : 내림차순, 안붙이면 오름차순(default)
--아무런 정렬조건 없이 조회할 경우 pk기준 오름차순
select * from author order by email desc;
select * from author;(order by id asc; 생략)
select * from author order by name desc;

--멀티컬럼 order by : 여러컬럼으로 정렬시에, 먼저쓴컬럼 우선정렬하고, 중복 시 그다음 컬럼으로 정렬적용.
select * from author order by name desc, email asc;

--결과값 개수 제한 가장 최근 데이터 하나만 조회
select * from author order by id desc limit 1;

--별칭(alias)를 이용한 select
select name as '이름', email as '이메일' from author;
select a.name, a.email from author as a;--테이블 여러개가 엮였을 때 별칭으로 테이블명시
select a.name, a.email from author a;

--null을 조회조건으로 활용
select * from author where password is null;
select * from author where password is not null;

--프로그래머스 sql문제풀이
--여러기준으로 정렬하기
--상위 n개 레코드
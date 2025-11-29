-- 사용자 목록 조회
select * from mysql.user;

-- 사용자생성 localhost는 원격접속 안됨(컴퓨터안접속) %는 원격접속(다른컴퓨터접속) 가능계정
create user 'marketing'@'%' identified by 'test4321';

-- 사용자에게 권한부여
grant select on board.author to 'marketing'@'%';
grant select, insert on board.* to 'marketing'@'%';
grant all privileges on board.* to 'marketing'@'%';

-- 사용자 권한회수
revoke select on board.author from 'marketing'@'%';

-- 사용자 권한 조회
show grants for 'marketing'@'%';

-- 사용자 계정삭제
drop user 'marketing'@'%';

ddl: create alter DROP
dml: insert update delete select
dcl: grant revoke
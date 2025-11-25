-- 트랜잭션 테스트를 위한 컬럼추가
alter table author add column post_count int default 0;
-- 트랜잭션 실습 맥락과 논리 이해
-- post에 글쓰기(insert). author의 post_count에 +1을 update하는 작업. 2개를 한트랜잭션으로 처리.
-- start transaction은 실질적인 의미는 없고, 트랜잭션의 시작이라는 상징적인 의미만 있는 코드.
start transaction;
update author set post_count=post_count+1 where id = 2;
insert into post(title, contents, author_id) values("hello","helloworld",2);
commit;

-- 위 트랜잭션은 실패시 자동으로 rollback이 어려움.
-- SQL의 stored 프로시저를 활용하여 성공시에는 commit, 실패시에는 rollback 등 동적인 프로그래밍
DELIMITER //--시스템 자체에 쿼리 저장
create procedure transaction_test()
begin
    declare exit handler for SQLEXCEPTION--error가 터지면
    begin
        rollback;--롤백한다
    end;
    start transaction;
    update author set post_count=post_count+1 where id = 2;
    insert into post(title, contents, author_id) values("hello", "hello ...", 2);
    commit;
end //
DELIMITER ;
--프로시저 호출
call transaction_test();
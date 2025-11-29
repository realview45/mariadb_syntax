-- view : 실제데이터를 참조만 하는 가상의 테이블. select만 가능 (중요 데이터 접근못하게, 권한제어)
-- 사용목적 : 1)권한분리 2)정보은닉

-- view 생성
create view author_view as select name, email from author;
create view author_view2 as select p.title, a.name, a.email 
    from post p inner join author a on p.author_id = a.id;

-- view 조회(테이블 조회와 동일)
select * from author_view;

-- view에 대한 권한 부여
grant select on board.author_view to 'marketing'@'%';

-- view삭제
drop view author_view;

-- 프로시저생성(잘안씀)
delimiter //
create procedure hello_procedure()
begin
    select "hello world";
end
// delimiter ;

-- 프로시저호출
call hello_procedure();

-- 프로시저삭제
drop procedure hello_procedure;

-- 회원목록조회 프로시저 생성 -> 한글명 프로시저 가능
delimiter //
create procedure 회원목록조회()
begin
    select * from author;
end
// delimiter ;

-- 회원상세조회 -> input(매개변수)값 여러개 사용 가능 -> 프로시저 호출시 순서에 맞게 매개변수 입력
delimiter //
create procedure 회원상세조회(in idInput bigint)
begin
    select * from author where id = idInput;
end
// delimiter ;

-- 전체회원수조회 -> 변수사용
delimiter //
create procedure 전체회원수조회()
begin
    -- 변수선언
    declare authorCount bigint;
    -- into를 통해 변수에 값 할당
    select count(*) into authorCount from author;
    -- 변수값 사용
    select authorCount;
end
// delimiter ;

-- 글쓰기
delimiter //
-- 사용자가 title, contents, 본인의 email값을 입력
create procedure 글쓰기(int titleInput varchar(255), in contentsInput varchar(255), in emailInput varchar(255))
begin
    -- begin밑에 declare를 통해 변수 선언
    declare postId bigint;
    declare authorId bigint;
    -- 아래 declare는 변수선언과는 상관없는 예외관련 특수문법 롤백 밑 세줄
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
        select id into authorId from author where email = emailInput;
        insert into post (title, contents) values (titleInput, contentsInput);
        select id into postId from post order by id desc limit 1;
        insert into author_post_list (post_id, author_id) values (postId, authorId);
    commit;

    select p.title, p.contents, ap.post_id, ap.author_id, a.name from post p 
    inner join author_post_list ap on p.id=ap.post_id 
    inner join author a on a.id=ap.author_id; 
end
// delimiter ;

-- 글삭제 -> if else문 나 혼자 쓴 글은 글까지 지우고, 같이 쓴 글은 참여자에서만 지운다. 
delimiter //
-- 사용자가 title, contents, 본인의 email값을 입력
create procedure 글삭제(in postIdInput bigint, in authorIdInput bigint)
begin
    declare authorCount bigint;
    -- 참여자의 수를 조회
    select count(*) into authorCount from author_post_list where post_id = postIdInput;
    if authorCount=1 then
        delete from author_post_list where post_id=postInput and author_id=authorIdInput;
        delete from post where id=postIdInput;
    else 
        delete from author_post_list where post_id=postInput and author_id=authorIdInput;
    end if;
end
// delimiter ;
delimiter //
-- 대량글도배 -> while문을 통한 반복문
create procedure 글도배(in count bigint, in emailInput varchar(255))
begin
    declare postId bigint;
    declare authorId bigint;
    declare countValue bigint default 0;
    
    while countValue<count do
        select id into authorId from author where email = emailInput;
        insert into post (title) values ("안녕하세요");
        select id into postId from post order by id desc limit 1;
        insert into author_post_list (post_id, author_id) values (postId, authorId);

        select p.title, p.contents, ap.post_id, ap.author_id, a.name from post p 
        inner join author_post_list ap on p.id=ap.post_id 
        inner join author a on a.id=ap.author_id; 

        set countValue = countValue+1;
    end while;
end
// delimiter ;
-- not null 제약조건 추가
alter table author modify column name varchar(255) not null;
-- not null 제약조건 제거 (덮어쓰기)
alter table author modify column name varchar(255);
-- not null, unique 동시 추가
alter table author modify column email varchar(255) unique not null;

-- pk/fk 추가/제거
-- pk 제약조건 삭제
alter table post drop primary key;
-- fk 제약조건 삭제
alter table post drop foreign key fk명;
-- pk 제약조건 추가
alter table post add constraint post_pk primary key(id);
-- fk 제약조건 추가
alter table post add constraint post_fk foreign key(author_id) references author(id);

--on delete/on update 제약조건 변경 테스트
alter table post add constraint post_fk foreign key(author_id) references author(id) 
                                                    on delete set null on update cascade;
--실습
--1.기존 fk 삭제
--2.새로운 fk 추가(on undate / on delete 변경)
--3.새로운 fk에 맞는 테스트 
--3-1)삭제 테스트
--3-2)수정 테스트

--요약
not null : create table post (id int not null)
        modify column age
fk : create table post (id... ,foreign key(author_id) references author(id))
        별도 명령문 alter table drop foreign key fk명;
부모 테이블에 없는 데이터가 자식테이블에 insert될 수 없다.(중요)
author_id에 author(id)에 없는 데이터가 들어오면 안된다.

부모테이블이 삭제되는 경우(hard delete): 안중요한 경우 자식도 안중요함 -> 같이삭제 cascade


옵션(안중요)
 on delete : 기본값 - restrict(막기), cascade(같이 삭제), set null(id가 삭제시 
                                                        author_id가 not null이면 불가능)
 on update : 기본값 - restrict, cascade, set null 

unique : create table post (id int unique , unique(id)) pk, unique 둘다 가능
        index에서 제거
pk : alter table add constraint   
별도 명령문



-- default 옵션
-- 어떤 컬럼이든 default 지정이 가능하지만, 일반적으로 enum타입 및 현재시간에서 많이 사용
alter table author modify column name varchar(255) default 'anonymous';
-- auto_increment : 숫자값을 입력 안했을때, 마지막에 입력된 가장 큰값에 +1만큼 자동으로 증가된 숫자값 적용 
-- id를 default 지정해주는 명령어
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;

-- uuid타입
alter table post add column user_id char(36) default (uuid());
                                    --16진수가 2진수로변환하기 용이해서 자주이용

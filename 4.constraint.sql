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

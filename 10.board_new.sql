-- 회원 테이블 생성 : id(pk), email(unique, not null), name(not null), password(not null)
create table author (id bigint primary key auto_increment, email varchar(255) unique not null, 
name varchar(255) not null, password varchar(255) not null);

-- 주소 테이블 생성 : id(pk), country(not null), city(not null), street(not null), author_id(fk, not null, unique)
create table address (id bigint auto_increment, country varchar(255) not null, 
city varchar(255) not null, street varchar(255) not null, author_id bigint not null unique, 
primary key(id),                                                                    --1대1관계 보장
foreign key(author_id) references author(id));

-- post 테이블 생성 : id, title(not null), contents
create table post (id bigint primary key auto_increment, 
title varchar(255) not null, contents varchar(255));

-- 연결(junction) 테이블 n:m을 n:1 두개로
create table author_post_list (id bigint primary key, 
author_id bigint not null, post_id bigint not null, 
foreign key(post_id)references post(id), foreign key(author_id)references author(id));
-- fk를 안걸어도 논리적으로 관계가 있다면 관계가 있음 실무에서 fk를 많이 안 검 일반적으로 건다.

-- 복합키를 이용한 연결(junction) 테이블 생성 
create table author_post_list ( author_id bigint not null, post_id bigint not null,
primary key(post_id, author_id),  
foreign key(post_id)references post(id), foreign key(author_id)references author(id));

-- 회원가입 및 주소생성
insert into author (id, email, name, password) values (3, 'ac@g.com', '홍', 135);
insert into author (id, email, name, password) values (4, 'bc@g.com', '김', 1357);
insert into author (id, email, name, password) values (5, 'cc@g.com', '박', 13579);
insert into address(country, city, street, author_id) values('korea','seoul','sindaebang', select id from author order by id desc limit 1);

-- 글쓰기
--최초 생성자
insert into post(title, contents);
insert into author_post_list (author_id, post_id) values(1, 1);
insert into author_post_list (author_id, post_id) values(select id from author where email = 'abc@naver.com');
insert into author_post_list (author_id, post_id) values(1, select id from post order where email = 'abc@naver.com');


--추후 참여자

-- 글 전체목록 조회하기 : 제목, 내용, 글쓴이 이름이 조회가 되도록 select쿼리 생성


select p.title, p.contents, a.name from post p 
left join author_post_list ap  on p.id=ap.post_id 
left join author a on ap.author_id=a.id;


select p.id, p.title, p.contents, a.name from post p 
inner join author_post_list ap  on p.id=ap.post_id --참여자 id만 알고 참여자 이름은 모름
inner join author a on ap.author_id=a.id;



--실습해보기
1.회원가입

insert into user (name) values ('김진경1');
insert into user (role, name) values ('seller','김진경2'); 
insert into user (role, name) values ('seller','김진경3'); 
insert into user (name) values ('김진경4'); 
insert into user (name) values ('김진경5'); 

2.
상품등록
insert into product(p_count, name, seller_id, price) 
values (3,'사과',2, 5000);
insert into product(p_count, name, seller_id, price) 
values (5,'배', 3, 6000);
insert into product(p_count, name, seller_id, price) 
values (2,'포도',2, 7000);

3.
주문하기
--4번 소비자가 사과를 1개, 배를 1개 주문
start transaction;
insert into ordernum(customer_id,time) values (4, current_timestamp());

insert into spec_order(order_id, product_id, product_count, price_ordered) 
values ((select id from ordernum order by id desc limit 
1), 1, 1, (select price from product where id=1));
update product set p_count=p_count-1 where id=1;
insert into spec_order(order_id, product_id, product_count, price_ordered) 
values ((select id from ordernum order by id desc limit 
1), 2, 1, (select price from product where id=2));
update product set p_count=p_count-1 where id=2;

--주문 당 주문상세정보 출력
select * from ordernum o inner join spec_order s on o.id = s.order_id;

--상품정보 조회
select * from product where name = '배';
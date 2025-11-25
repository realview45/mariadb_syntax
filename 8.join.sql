-- join보다 서브쿼리는 성능이 떨어진다

-- case1 : author inner join post 일단 이너조인
--글쓴적이 있는 글쓴이와 그 글쓴이가 쓴 글의 목록 출력
select * from author inner join post on author.id = post.author_id;

-- case2 : post inner join author
--글쓴이가 있는 글과 해당 글의 글쓴이를 조회
select * from post p inner join author a on a.id = p.author_id;
--글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력
select p.*, a.email from post p inner join author a on a.id = p.author_id;

-- case3 : author left join post
--글쓴이는 모두조회하되, 만약 쓴글이 있다면 글도 함께 조회
select a.*, p.* from author a left join post p on a.id=p.author_id;

-- case4 : post left join author
--글을 모두 조회하되, 글쓴이가 있다면 글쓴이도 함께 조회
select a.*, p.* from post p left join author a on a.id=p.author_id;

--실습)글쓴이가 있는 글 중에서 글의 제목과 저자의 email, 저자의 나이를 출력하되, 저자의 나이가 30세 이상인글만 출력
select p.title, a.email, a.age from post p inner join author a on a.id=p.author_id where a.age>=30;

--실습)글의 저자의 이름이 빈값(null)이 아닌 글목록만을 출력.
select p.* from post p inner join author a on a.id=p.author_id where a.name is not null; 

--조건에 맞는 도서와 저자 리스트 출력
--없어진 기록 찾기

-- union : 두 테이블의 select 결과를 횡으로 결합(안중요)
-- union시킬 때 컬럼의 개수와 컬럼의 타입이 같아야함
select name, email from author union select title, contents from post;
-- union은 기본적으로 distinct 적용. 중복허용하려면 union all 사용.
select name, email from author union all select title, contents from post;

-- 서브쿼리 : select문 안에 또다른 select문을 서브쿼리라함
-- where절 안에 서브쿼리
-- 한번이라도 글을 쓴 author의 목록조회(중복제거)
select distinct a.* from author a inner join post p on a.id=p.author_id;

--null값은 in조건절에서 자동으로 제외
select * from author where id in (select author_id from post);

-- 컬럼 위치에 서브쿼리
-- 회원별로 본인의 쓴 글의 개수를 출력. ex)email, post_count 
select email, (select count(*) from post p where p.author_id=a.id) -- 매번 조회하러가서 조인보다 성능안좋음
    as post_count from author a;

-- from절 위치에 서브쿼리(잘 안씀)
select a.* from (select * from author) as a;

-- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화하여, 하나의 행(row)처럼 취급
select author_id from post group by author_id;
select author_id, count(*) from post group by author_id; --null도 카운트

-- 회원별로 본인의 쓴 글의 개수를 출력 ex)email, post_count (left join으로 풀이)모르겠음
select a.email, count(p.id) from author a left join post p on a.id=p.author_id group by a.email;
    --author를 전부다 출력하되 이메일이 중복된 값은 묶는다. p.id는 not null이므로 개수 세기에 적당
                                                                                --한행씩 나눠주기
                                                                                --default는 전체
select a.email, count(IFNULL(P.ID, NULL)) from author a 
left join post p on a.id=p.author_id 
group by a.email;


-- 집계함수
select count(*) from author;
select sum(age) from author;
select avg(age) from author;
-- 소수점 3번째 자리까지 반올림
select round(avg(age), 3) from author;

--group by와 집계함수
--회원의 이름별 회원숫자를 출력하고, 이름별 나이의 평균값을 출력하라.
select name, count(*) as count, avg(age) as age from author group by name;
                               그룹바이된 결과값 내에서의 카운트, 평균


-- where와 group by
-- 날짜값이 null인 데이터는 제외하고, 날짜별 post 글의 개수를 출력.
select date_format(created_time,'%Y-%m-%d') as date, count(*) from post 
where created_time is not null 
group by date_format(created_time,'%Y-%m-%d')
order by date;


select date_format(created_time,'%Y-%m-%d'), count(*) from post 
where created_time is not null 
group by date_format(created_time,'%Y-%m-%d');

--프로그래머스
--자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
--입양 시각 구하기(1)

--group by와 having
--having은 group by를 통해 나온 집계값에 대한 조건
--글을 2번 이상 쓴 사람 author_id ID찾기
select author_id, count(*) from post group by author_id; 
select author_id from post group by author_id having count(*) >=2;

--동명 동물 수 찾기 -> having
--카테고리 별 도서 판매량 집계하기 -> join까지
--조건에 맞는 사용자와 총 거래금액 조회하기 -> join까지

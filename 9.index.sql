-- pk, fk, unique 제약조건 추가시에 해당컬럼에 대해 index페이지가 자동생성
-- 별도의 컬럼에 대해 index 추가 생성 가능

-- index 조회
show index from author;

-- 기존 index 삭제
alter table author drop index 인덱스명;

-- 신규 index 생성
create index 인덱스명 on 테이블명(컬럼명);
create index name_index on author(name);

-- index는 1컬럼 뿐만 아니라, 2컬럼을 대상으로 1개의 index를 설정하는 것도 가능
-- 이경우 두컬럼을 and조건으로 조회해야만 index를 사용
create index 인덱스명 on 테이블명(컬럼1, 컬럼2);
create index name_age_index on author(name,age);

--index성능테스트
--기존테이블 삭제 후 간단한 테이블로 index설정 또는 index미설정 테스트
create table author(id bigint auto_increment, email varchar(255), name varchar(255), primary key(id));
create table author(id bigint auto_increment, email varchar(255) unique, name varchar(255), primary key(id));

-- 아래 프로시저를 통해 수십만건의 데이터 insert후에 index생성 전후에 따라 조회성능확인
DELIMITER //
CREATE PROCEDURE insert_authors()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE email VARCHAR(100);
    DECLARE batch_size INT DEFAULT 10000; -- 한 번에 삽입할 행 수
    DECLARE max_iterations INT DEFAULT 100; -- 총 반복 횟수 (1000000 / batch_size)
    DECLARE iteration INT DEFAULT 1;
    WHILE iteration <= max_iterations DO
        START TRANSACTION;
        WHILE i <= iteration * batch_size DO
            SET email = CONCAT('bradkim', i, '@naver.com');
            INSERT INTO author (email) VALUES (email);
            SET i = i + 1;
        END WHILE;
        COMMIT;
        SET iteration = iteration + 1;
        DO SLEEP(0.1); -- 각 트랜잭션 후 0.1초 지연
    END WHILE;
END //
DELIMITER ;

select * from author order by id desc limit 1;
시간재기
select * from author where email='bradkim1000000@naver.com'; 0.187sec 0.000sec(unique)
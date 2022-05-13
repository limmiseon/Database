drop table if exists Answer; # 테이블이 있다면 지우기
create table Answer( # 정답 테이블
	subjectID int not null primary key,
    a01 int, a02 int, a03 int, a04 int, a05 int, a06 int, a07 int, a08 int, a09 int, a10 int,
    a11 int, a12 int, a13 int, a14 int, a15 int, a16 int, a17 int, a18 int, a19 int, a20 int);

drop table if exists Testing; # 테이블이 있다면 지우기
create table Testing( # 시험 테이블
	subjectID int not null,
    stu_name varchar(20),
    stu_id int not null,
    a01 int, a02 int, a03 int, a04 int, a05 int, a06 int, a07 int, a08 int, a09 int, a10 int,
    a11 int, a12 int, a13 int, a14 int, a15 int, a16 int, a17 int, a18 int, a19 int, a20 int,
    primary key(subjectID, stu_id));

drop table if exists Scoring; # 테이블이 있다면 지우기
create table Scoring( # 채점 테이블
	subjectID int not null,
    stu_name varchar(20),
    stu_id int not null,
    a01 int, a02 int, a03 int, a04 int, a05 int, a06 int, a07 int, a08 int, a09 int, a10 int,
    a11 int, a12 int, a13 int, a14 int, a15 int, a16 int, a17 int, a18 int, a19 int, a20 int,
    score int,
    primary key(subjectID, stu_id));
    
drop table if exists Reporttable; # 테이블이 있다면 지우기
create table Reporttable( # 채점 테이블
	stu_name varchar(20),
    stu_id int not null primary key,
    kor int, eng int, mat int);

# 정답 테이블 데이터 추가
delete from Answer;
insert into Answer value (1,
3, 4, 2, 1, 4, 3, 2, 2, 3, 1, 5, 1, 4, 2, 1, 3, 2, 1, 5, 4);
insert into Answer value (2,
1, 2, 4, 5, 3, 1, 1, 4, 2, 3, 2, 4, 3, 5, 2, 5, 4, 3, 2, 5);
insert into Answer value (3,
4, 1, 3, 2, 2, 4, 1, 5, 4, 2, 3, 2, 1, 5, 3, 4, 2, 5, 1, 3);

# 시험 테이블 데이터 추가 프로시저 만들기
drop procedure if exists insert_testing; # 프로시저 지우기
delimiter $$
create procedure insert_testing(_last integer) # integer를 인자로 받기
begin
# 변수 선언
declare _name varchar(20);
declare _id integer;
declare _cnt integer;
set _cnt = 0;
delete from Testing where stu_id > 0; # 데이터 지우기
	_loop: loop # 루프 시작
		set _cnt = _cnt + 1;
		set _name = concat("홍길", cast(_cnt as char(4))); # concat으로 문자열 붙이기, cast로 형변환
		set _id = 209900 + _cnt;
		
        # 데이터 추가
		insert into Testing value (1, _name, _id, 
			rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1,
            rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1);
		insert into Testing value (2, _name, _id, 
			rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1,
            rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1);
		insert into Testing value (3, _name, _id, 
			rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1,
            rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1, rand()*4+1);
		
		if _cnt = _last then # 만약 _cnt값이 _last값과 같다면
			leave _loop; # 루프 나가기
		end if;
	end loop _loop;
end $$

call insert_testing(1000); # 프로시저 호출
select * from Testing;

# 채점하기
delete from Scoring;
insert into Scoring # 데이터 추가
	select b.subjectID, b.stu_name, b.stu_id,
    (select if(a.a01 = b.a01, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a02 = b.a02, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a03 = b.a03, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a04 = b.a04, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a05 = b.a05, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a06 = b.a06, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a07 = b.a07, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a08 = b.a08, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a09 = b.a09, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a10 = b.a10, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a11 = b.a11, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a12 = b.a12, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a13 = b.a13, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a14 = b.a14, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a15 = b.a15, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a16 = b.a16, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a17 = b.a17, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a18 = b.a18, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a19 = b.a19, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    (select if(a.a20 = b.a20, 1, 0) from Answer as a where a.subjectID = b.subjectID),
    count(1)
    from Testing as b;
    
select * from Scoring;
select(select count(*) *5 
set sql_safe_updates = 0;

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

# 채점을 위한 임시 view 생성
drop view if exists examview;
create view examview(subjectID, stu_name, stu_id, a01, a02, a03, a04, a05, a06, a07, a08, a09, a10,
					a11, a12, a13, a14, a15, a16, a17, a18, a19, a20)
as select  b.subjectID, b.stu_name, b.stu_id,
    (select if(a.a01 = b.a01, 1, 0) from Answer as a where a.subjectID = b.subjectID), # testing 테이블과 answer테이블의 값이 같다면(정답) 1, 다르다면(오답)2
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
    (select if(a.a20 = b.a20, 1, 0) from Answer as a where a.subjectID = b.subjectID)
    from Testing as b;
select * from examview;

# 채점 테이블 만들기
delete from Scoring; # 테이블이 있다면 지우기
insert into Scoring # 데이터 추가
	select subjectID, stu_name, stu_id, a01, a02, a03, a04, a05, a06, a07, a08, a09, a10,
			a11, a12, a13, a14, a15, a16, a17, a18, a19, a20,
			(a01+a02+a03+a04+a05+a06+a07+a08+a09+a10+a11+a12+a13+a14+a15+a16+a17+a18+a19+a20)*5
    from examview;
select * from Scoring;

# 채점 리포트 테이블 만들기
delete from Reporttable; # 테이블이 있다면 지우기
insert into Reporttable select distinct b.stu_name, b.stu_id,
	(select a.score from Scoring as a where a.subjectID = 1 and a.stu_id = b.stu_id) as kor,
    (select a.score from Scoring as a where a.subjectID = 2 and a.stu_id = b.stu_id) as eng,
    (select a.score from Scoring as a where a.subjectID = 3 and a.stu_id = b.stu_id) as mat
    from Scoring as b;
 select * from Reporttable;
 
 # 채점리포트에 합계, 평균, 등수 더하여 출력
 select *, kor+eng+mat as sum, (kor+eng+mat)/3 as ave,
 (select count(*)+1 from Reporttable as b where (b.kor+b.eng+b.mat) > (a.kor+a.eng+a.mat)) as ranking from Reporttable as a;
 
 # 과목별, 문제별 득점자수와 득점률 리포트를 출력하는 프로시저 생성
drop procedure if exists get_test_rest;
delimiter $$
create procedure get_test_rest(_subjectID integer)
begin
declare total integer;
declare sub integer;
set total = (select count(*) from Scoring where subjectID = _subjectID); # 비율 계산을 위해 데이터 총 갯수 구하기
	
	select subjectID,
	(select count(*) from Scoring where a01 = 1 and subjectID=_subjectID) as a01, (((select count(*) from Scoring where a01 = 1 and subjectID=_subjectID)/total)*100) as a01득점률,
	(select count(*) from Scoring where a02 = 1 and subjectID=_subjectID) as a02, (((select count(*) from Scoring where a02 = 1 and subjectID=_subjectID)/total)*100) as a02득점률,
	(select count(*) from Scoring where a03 = 1 and subjectID=_subjectID) as a03, (((select count(*) from Scoring where a03 = 1 and subjectID=_subjectID)/total)*100) as a03득점률,
	(select count(*) from Scoring where a04 = 1 and subjectID=_subjectID) as a04, (((select count(*) from Scoring where a04 = 1 and subjectID=_subjectID)/total)*100) as a04득점률,
	(select count(*) from Scoring where a05 = 1 and subjectID=_subjectID) as a05, (((select count(*) from Scoring where a05 = 1 and subjectID=_subjectID)/total)*100) as a05득점률,
	(select count(*) from Scoring where a06 = 1 and subjectID=_subjectID) as a06, (((select count(*) from Scoring where a06 = 1 and subjectID=_subjectID)/total)*100) as a06득점률,
	(select count(*) from Scoring where a07 = 1 and subjectID=_subjectID) as a07, (((select count(*) from Scoring where a07 = 1 and subjectID=_subjectID)/total)*100) as a07득점률,
	(select count(*) from Scoring where a08 = 1 and subjectID=_subjectID) as a08, (((select count(*) from Scoring where a08 = 1 and subjectID=_subjectID)/total)*100) as a08득점률,
	(select count(*) from Scoring where a09 = 1 and subjectID=_subjectID) as a09, (((select count(*) from Scoring where a09 = 1 and subjectID=_subjectID)/total)*100) as a09득점률,
	(select count(*) from Scoring where a10 = 1 and subjectID=_subjectID) as a10, (((select count(*) from Scoring where a10 = 1 and subjectID=_subjectID)/total)*100) as a10득점률,
	(select count(*) from Scoring where a11 = 1 and subjectID=_subjectID) as a11, (((select count(*) from Scoring where a11 = 1 and subjectID=_subjectID)/total)*100) as a11득점률,
	(select count(*) from Scoring where a12 = 1 and subjectID=_subjectID) as a12, (((select count(*) from Scoring where a12 = 1 and subjectID=_subjectID)/total)*100) as a12득점률,
	(select count(*) from Scoring where a13 = 1 and subjectID=_subjectID) as a13, (((select count(*) from Scoring where a13 = 1 and subjectID=_subjectID)/total)*100) as a13득점률,
	(select count(*) from Scoring where a14 = 1 and subjectID=_subjectID) as a14, (((select count(*) from Scoring where a14 = 1 and subjectID=_subjectID)/total)*100) as a14득점률,
	(select count(*) from Scoring where a15 = 1 and subjectID=_subjectID) as a15, (((select count(*) from Scoring where a15 = 1 and subjectID=_subjectID)/total)*100) as a15득점률,
	(select count(*) from Scoring where a16 = 1 and subjectID=_subjectID) as a16, (((select count(*) from Scoring where a16 = 1 and subjectID=_subjectID)/total)*100) as a16득점률,
	(select count(*) from Scoring where a17 = 1 and subjectID=_subjectID) as a17, (((select count(*) from Scoring where a17 = 1 and subjectID=_subjectID)/total)*100) as a17득점률,
	(select count(*) from Scoring where a18 = 1 and subjectID=_subjectID) as a18, (((select count(*) from Scoring where a18 = 1 and subjectID=_subjectID)/total)*100) as a18득점률,
	(select count(*) from Scoring where a19 = 1 and subjectID=_subjectID) as a19, (((select count(*) from Scoring where a19 = 1 and subjectID=_subjectID)/total)*100) as a19득점률,
	(select count(*) from Scoring where a20 = 1 and subjectID=_subjectID) as a20, (((select count(*) from Scoring where a20 = 1 and subjectID=_subjectID)/total)*100) as a20득점률
	from Scoring where subjectID=_subjectID group by subjectID;
    
end $$

call get_test_rest(1);

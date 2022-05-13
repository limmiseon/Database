drop table if exists examtable; # 테이블 지우기
create table examtable( # 테이블 생성
	name varchar(20),
	id int not null primary key,
	kor int, eng int, mat int);
desc examtable; # 테이블 구조 확인

drop procedure if exists insert_examtable; # 프로시저 지우기
delimiter $$
create procedure insert_examtable(_last integer) # integer를 인자로 받기
begin
# 변수 선언
declare _id integer;
declare _name varchar(20);
declare _cnt integer;
set _cnt = 0;
delete from examtable where id > 0; # 데이터 지우기
	_loop: loop # 루프 시작
		set _cnt = _cnt + 1;
		set _name = concat("홍길", cast(_cnt as char(4))); # concat으로 문자열 붙이기, cast로 형변환
		set _id = 209900 + _cnt;
		
		insert into examtable value (_name, _id, rand()*100, rand()*100, rand()*100); # 데이터 추가
		
		if _cnt = _last then # 만약 _cnt값이 _last값과 같다면
			leave _loop; # 루프 나가기
		end if;
	end loop _loop;
end $$

call insert_examtable(1000); # 프로시저 호출

# 임시 테이블 역할을 하는 view 만들기
drop view if exists examview;
create view examview(name, id, kor, eng, mat, tot, ave, ran)
as select *, # 이름, 학번, 국어, 영어, 수학
	b.kor + b.eng + b.mat, #총점
    (b.kor+ b.eng + b.mat)/3, #평균
    (select count(*)+1 from examtable as a where (a.kor + a.eng + a.mat) > (b.kor + b.eng + b.mat)) #등수
    from examtable as b;
    
select * from examview;
select name, ran from examview;
select * from examview where ran > 5;
# view는 테이블이 아니기 때문에 수정, 삭제 등이 제한된다.
insert into examview values ("나연", 309933, 100, 100, 100, 300, 300, 1); # 에러

drop table if exists examtableEX; # 테이블이 있다면 지움
create table examtableEX(
	name varchar(20),
    id int not null primary key,
    kor int, eng int, mat int, sum int, ave double, ranking int);
desc examtableEX;

insert into examtableEX # 데이터 추가
	select *, b.kor + b.eng + b.mat, (b.kor + b.eng+ b.mat)/3,
    (select count(*)+1 from examtable as a where (a.kor + a.eng + a.mat) > (b.kor + b.eng + b.mat)) # 등수
    from examtable as b;
    
select * from examtableEX order by ranking desc;
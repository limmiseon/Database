drop table if exists examtable; # 테이블 지우기
create table examtable( # 테이블 생성
	id int not null primary key,
	name varchar(20),
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
		
		insert into examtable value (_id, _name, rand()*100, rand()*100, rand()*100); # 데이터 추가
		
		if _cnt = _last then # 만약 _cnt값이 _last값과 같다면
			leave _loop; # 루프 나가기
		end if;
	end loop _loop;
end $$

call insert_examtable(100); # 프로시저 호출

# 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등수 테이블
select id as 학번, name as 이름, kor as 국어, eng as 영어, mat as 수학, kor+eng+mat as 총점, (kor+eng+mat)/3 as 평균,
(select count(*)+1 from examtable as b where (b.kor+b.eng+b.mat) > (a.kor+a.eng+a.mat)) as 등수 from examtable as a;

# 등수 출력 함수
drop function if exists _get_rank; # 함수 지우기
delimiter $$
create function _get_rank(_id integer) returns integer
begin
	declare _rank integer; # 변수 선언(등수)
    select count(*)+1 into _rank from examtable as b where (b.kor+b.eng+b.mat) > (select (a.kor+a.eng+a.mat) from examtable as a where id = _id);
    return _rank; # 리턴값
end $$

# 등수순으로 오름차순 정렬
select id as 학번, name as 이름, kor as 국어, eng as 영어, mat as 수학, kor+eng+mat as 총점, (kor+eng+mat)/3 as 평균,
_get_rank(id) as 등수 from examtable order by 등수;
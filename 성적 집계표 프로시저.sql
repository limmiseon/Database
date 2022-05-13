drop table if exists grade_card; # 테이블 삭제
create table grade_card(
	id int not null primary key,
	name varchar(20),
	kor int, eng int, mat int);

# 데이터 추가 프로시저 만들기
drop procedure if exists _calc; # 프로시저 지우기
DELIMITER $$
create procedure _calc(_last integer) # integer를 인자로 받기
begin
# 변수 선언
declare _id integer; # 학번
declare _name varchar(20); # 이름
declare _cnt integer;
set _cnt = 0;
delete from grade_card where id > 0; # 데이터 지우기
	_loop : loop # 루프 시작
		set _cnt = _cnt + 1;
        set _name = concat("홍길", cast(_cnt as char(4))); # concat을 이용하여 문자열 붙이기, cast로 형변환
        set _id = _cnt;
        
        insert into grade_card value (_id, _name, rand()*100, rand()*100, rand()*100); # 테이블에 데이터 추가
        
        if _cnt = _last then # 만약 _cnt값이 _last값과 같다면
			leave _loop; # 루프 나가기
		end if;
	end loop _loop;
end $$ # 리턴값 보내기
DELIMITER ;

call _calc(1000); # 프로시저 호출
select * from grade_card;

# 페이지 출력 프로시저 만들기
drop procedure if exists print_report; # 프로시저 지우기
DELIMITER $$
create procedure print_report(_start integer, _last integer) # integer를 인자로 받기
begin
	declare _page_start int; # 페이지 시작 번호 변수
    declare _page_last int; # 마지막 페이지를 구하는 변수(나머지가 없을때)
    declare _page_select double; # 마지막 페이지(나머지가 있을때)
    declare _total int; # 누적 페이지 변수
    set _page_start = (_start * _last) - _last; # 페이지 시작 번호 구하기
    set _page_last = (select count(*) from grade_card) / _last; # 마지막 페이지 구하기(나머지 x)
    set _page_select = (select count(*) from grade_card) % _last; # 마지막 페이지 구하기(나머지 o)
    
    if _start < 1 then # 1보다 작은 수가 들어오면 제일 처음 페이지로 세팅
		set _page_start = 0;
	end if;
    
    if _start > _page_last then # 마지막 페이지 수보다 큰 수가 들어오면 마지막 페이지로 세팅
		if _page_select = 0 then
			set _page_start = (_page_last - 1) * _last;
		else
			set _page_start = (_page_last) * _last;
		end if;
	end if;
    
    set _total = _page_start + _last; # 누적 페이지
    
    # 결과 테이블1(내용테이블)
    select id as 번호, name as 이름, kor as 국어, eng as 영어, mat as 수학, kor+mat+eng as 총점, round((kor+eng+mat)/3,1) as 평균,
    (select count(*)+1 from grade_card as b where (b.kor+b.eng+b.mat) > (a.kor+a.eng+a.mat)) as 등수 from grade_card as a limit _page_start, _last;
    # 결과 테이블2(현재페이지)
    select sum(kor) as 국어합계, sum(eng) as 영어합계, sum(mat) as 수학합계, sum(kor+eng+mat) as 총점합계, sum((kor+eng+mat)/3) as 평균합계, 
    avg(kor) as 국어평균, avg(eng) as 영어평균, avg(mat) as 수학평균, avg(kor+eng+mat) as 총점평균, avg((kor+eng+mat)/3) as 페이지평균 
    from (select kor, eng, mat, kor+eng+mat, (kor+eng+mat)/3 from grade_card limit _page_start, _last)as subQuery;
    # 결과 테이블3(누적페이지)
    select sum(kor) as 국어누적합, sum(eng) as 영어누적합, sum(mat) as 수학누적합, sum(kor+eng+mat) as 총점누적합, sum((kor+eng+mat)/3) as 평균누적합, 
    avg(kor) as 국어누적평균, avg(eng) as 영어누적평균, avg(mat) as 수학누적평균, avg(kor+eng+mat) as 총점누적평균, avg((kor+eng+mat)/3) as 누적평균 
    from (select kor, eng, mat, kor+eng+mat, (kor+eng+mat)/3 from grade_card limit _total)as subQuery;

end $$ # 리턴값 보내기
DELIMITER ;

call print_report(0,25);
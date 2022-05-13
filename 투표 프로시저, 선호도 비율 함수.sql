drop table if exists tupyo; # 테이블 지우기
create table tupyo( # 투표 테이블 생성
	name varchar(20),
    age int);
    
# 투표 프로시저
drop procedure if exists input_data; # 프로시저 삭제
delimiter $$
create procedure input_data(_last integer) # 인자를 integer로 받기
begin
declare _memberName integer; # 1번 ~ 9번 멤버 선택 변수
declare _cnt integer;
set _cnt = 0;
delete from tupyo where age > 0;
	_loop: LOOP		
		set _cnt = _cnt + 1;
        set _memberName = rand()*8+1; # 멤버 랜덤 선택
        insert into tupyo value (cast(_memberName as char(1)), rand()*8+1);
        if _cnt = _last then
			leave _loop;
		end if;
	end loop _loop;
    
    # 멤버 번호 이름으로 바꾸기
    update tupyo set name = '나연' where name = '1';
    update tupyo set name = '정연' where name = '2';
    update tupyo set name = '모모' where name = '3';
    update tupyo set name = '사나' where name = '4';
    update tupyo set name = '지효' where name = '5';
    update tupyo set name = '미나' where name = '6';
    update tupyo set name = '다현' where name = '7';
    update tupyo set name = '채영' where name = '8';
    update tupyo set name = '쯔위' where name = '9';
end $$

call input_data(1000); # 무작위 선호도 투표
select name as 이름, age * 10 as 연령대 from tupyo;

# 선호도 비율 함수 만들기
drop function if exists _get_rate; # 함수 삭제
delimiter $$
create function _get_rate(_name varchar(20)) returns double
begin
	declare _rate double;
    # 선호도 비율 계산
	select round(count(name)/(select count(*) from tupyo)*100,3) into _rate from tupyo where name = _name;
return _rate; # 값 반환
end $$

select name as 이름, count(name) as 득표수, _get_rate(name) as 선호도비율 from tupyo group by name order by 득표수;

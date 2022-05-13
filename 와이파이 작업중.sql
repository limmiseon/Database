# 와이파이 페이지 출력 프로시저 만들기
drop procedure if exists print_report; # 프로시저 지우기
DELIMITER $$
create procedure print_report(_start integer, _last integer) # integer를 인자로 받기
begin
	declare _page_start int; # 페이지 시작 번호 변수
    declare _page_last int; # 마지막 페이지를 구하는 변수(나머지가 없을때)
    declare _page_select double; # 마지막 페이지(나머지가 있을때)
    set _page_start = (_start * _last) - _last; # 페이지 시작 번호 구하기
    set _page_last = (select count(*) from freewifi) / _last; # 마지막 페이지 구하기(나머지 x)
    set _page_select = (select count(*) from freewifi) % _last; # 마지막 페이지 구하기(나머지 o)
    
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
    
    select num as 번호, place_addr_road as 주소, latitude as 위도, longitude as 경도, 
    (SQRT(POWER(latitude - 37.4207,2) + POWER(longitude - 127.2428,2))) as 거리 # 우리집과의 거리
    from freewifi as a limit _page_start, _last;
    
end $$ # 리턴값 보내기
DELIMITER ;

call print_report(150,25); # 프로시저 호출
set sql_safe_updates=0;
drop table if exists reservation; # 테이블이 있다면 삭제
create table reservation( # 테이블 생성
	name varchar(20), # 이름
    reserve_date date, # 이용 날짜
    room int, # 룸 번호
    addr varchar(20), # 주소
    tel varchar(20), # 전화번호
    ipgum_name varchar(20), # 입금자명
    memo varchar(50), # 남기실 말
    input_data date); # 예약 일자

delete from reservation where room > 0; # 데이터 삭제
insert into reservation values ("나연", "2022-05-18", 1, "서울", "010-0101-0101", "나연", "따뜻한 방 주세요", now());
insert into reservation values ("미나", "2022-05-18", 2, "서울", "010-0101-0101", "미나", "따뜻한 방 주세요", now());
insert into reservation values ("모모", "2022-05-20", 1, "서울", "010-0101-0101", "모모", "따뜻한 방 주세요", now());
insert into reservation values ("정연", "2022-05-20", 3, "서울", "010-0101-0101", "모모", "따뜻한 방 주세요", now());
insert into reservation values ("사나", "2022-05-21", 1, "서울", "010-0101-0101", "사나", "따뜻한 방 주세요", now());
insert into reservation values ("지효", "2022-05-22", 1, "서울", "010-0101-0101", "지효", "따뜻한 방 주세요", now());

# 한달간의 예약상황을 보여주기 위한 테이블을 만드는 프로시저
drop procedure if exists resvstat_calc; # 프로시저가 있다면 삭제
delimiter $$
create procedure resvstat_calc()
begin
    declare _cnt integer;
    declare _room1 varchar(20);
    declare _room2 varchar(20);
    declare _room3 varchar(20);
    set _cnt = 0;
    #################################
    drop table if exists reserv_stat; # 테이블이 있다면 삭제
    create table reserv_stat(
		reserve_date date not null, # 이용 날짜
        room1 varchar(20),
        room2 varchar(20),
        room3 varchar(20),
        primary key(reserve_date));
	
	_loop : loop
        insert into reserv_stat value (DATE_ADD(NOW(), INTERVAL _cnt DAY), "예약가능", "예약가능", "예약가능"); # date_add 함수를 이용해 날짜 더하기
        set _cnt = _cnt + 1;
        if _cnt = DAY(last_day(now())) then # 해당 월의 날짜만큼 반복
			leave _loop;
		end if;
	end loop _loop;
    
    update reserv_stat x # 룸1 예약자 업데이트
	inner join reservation y on x.reserve_date = y.reserve_date
	set x.room1 = y.name
	where y.room = 1;
    
	update reserv_stat x # 룸2 예약자 업데이트
	inner join reservation y on x.reserve_date = y.reserve_date
	set x.room2 = y.name
	where y.room = 2;

	update reserv_stat x # 룸3 예약자 업데이트
	inner join reservation y on x.reserve_date = y.reserve_date
	set x.room3 = y.name
	where y.room = 3;
    
end $$

call resvstat_calc; # 프로시저 호출
select * from reserv_stat;

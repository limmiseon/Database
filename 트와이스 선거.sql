drop table if exists hubo;
create table hubo(
	kiho int not null,
    name varchar(10),
    gongyak varchar(50),
    primary key(kiho),
    index(kiho)); # 빠른 검색을 위한 index 추가
desc hubo;

delete from hubo where kiho > 0; # 데이터 삭제
insert into hubo values (1, "나연", "정의사회 구현");
insert into hubo values (2, "정연", "모두 10억 줌");
insert into hubo values (3, "모모", "주 3일제 시행");
insert into hubo values (4, "사나", "집 줄게");
insert into hubo values (5, "지효", "하루 수면시간 10시간 보장");
insert into hubo values (6, "미나", "소원 하나씩 들어줌");
insert into hubo values (7, "다현", "평생 병원비 무료");
insert into hubo values (8, "채영", "하루 근무시간 4시간");
insert into hubo values (9, "쯔위", "매 끼니 제공");

drop table if exists tupyo002; # 테이블이 있다면 삭제
create table tupyo002(
	kiho int,
    age int,
    foreign key(kiho) references hubo(kiho)); # 투표테이블의 기호는 후보테이블의 기호와 연동됨
desc tupyo002;

# 투표 데이터 추가 프로시저
delete from tupyo002 where kiho > 0; # 데이터 삭제
drop procedure if exists insert_tupyo002; # 프로시저 삭제
delimiter $$
create procedure insert_tupyo002(_limit integer)
begin
declare _cnt integer;
set _cnt = 0;
	_loop : loop # 루프 시작
		set _cnt = _cnt + 1;
        insert into tupyo002 value (rand()*8+1, rand()*8+1); # 기호와 연령대를 랜덤함수로 추가
        if _cnt = _limit then # 루프문 탈출 조건
			leave _loop;
		end if;
	end loop _loop; # 루프 끝
end $$

call insert_tupyo002(1000);

select kiho as 기호, name as 이름, gongyak as 공약 from hubo;
select kiho as 투표한기호, age * 10 as 투표자연령대 from tupyo002;
select kiho, count(*) from tupyo002 group by kiho;

# join
select b.name, b.gongyak, count(a.kiho)
	from tupyo002 as a, hubo as b # 투표 테이블 = a, 후보 테이블 = b
    where a.kiho = b.kiho # a 테이블의 기호와 b 테이블의 기호가 같을 때
    group by a.kiho; # a의 기호 칼럼으로 묶음
    
# select 안에 select
select (select name from hubo where kiho = a.kiho), # 후보 테이블에서 투표 테이블의 기호와 같은 이름을 가져옴
	(select gongyak from hubo where kiho = a.kiho), # 후보 테이블에서 투표 테이블의 기호와 같은 공약을 가져옴
	count(a.kiho) # 투표 테이블의 기호를 셈(투표 수)
    from tupyo002 as a # 투표 테이블을 a로 설정
    group by a.kiho; # 투표 테이블의 기호 칼럼을 묶음
    
drop table if exists tupyo 003; # 테이블이 있다면 지움
create table tupyo003(
	kiho1 int,
    kiho2 int,
    kiho3 int,
    age int);
desc tupyo2;

# 투표 데이터 추가 프로시저
delete from tupyo003 where kiho1 > 0; # 데이터 삭제
drop procedure if exists insert_tupyo003; # 프로시저 삭제
delimiter $$
create procedure insert_tupyo003(_limit integer)
begin
declare _cnt integer;
set _cnt = 0;
	_loop : loop # 루프 시작
		set _cnt = _cnt + 1;
        insert into tupyo003 value (rand()*8+1, rand()*8+1, rand()*8+1, rand()*8+1);
        if _cnt = _limit then # 루프문 탈출 조건
			leave _loop;
		end if;
	end loop _loop; # 루프 끝
end $$

call insert_tupyo003(1000);
select * from tupyo003;
 
# tuypo003의 kiho1, kiho2, kiho3을 기호에 대한 후보자 이름으로 작성 (join)
select a.age, h1.name as 투표1, h2.name as 투표2, h3.name as 투표3
	from tupyo003 as a, hubo as h1, hubo as h2, hubo as h3
	where a.kiho1 = h1.kiho and a.kiho2 = h2.kiho and a.kiho3 = h3.kiho;
 
 # tuypo003의 kiho1, kiho2, kiho3을 기호에 대한 후보자 이름으로 작성 (subquery)
 select a.age,
	(select name from hubo where a.kiho1 = kiho) as 투표1, # 후보 테이블에서 투표 테이블의 기호와 같은 이름을 가져옴
	(select name from hubo where a.kiho2 = kiho) as 투표2,
	(select name from hubo where a.kiho3 = kiho) as 투표3
	from tupyo003 as a;
    
# 멤버별 득표수 출력(중복으로 2개, 3개 찍은 사람도 있으나 한번만 집계)
select
	(select count(*) from tupyo003 where kiho1=1 or kiho2=1 or kiho3=1) as 나연,
 	(select count(*) from tupyo003 where kiho1=2 or kiho2=2 or kiho3=2) as 정연,
	(select count(*) from tupyo003 where kiho1=3 or kiho2=3 or kiho3=3) as 모모,
	(select count(*) from tupyo003 where kiho1=4 or kiho2=4 or kiho3=4) as 사나,
	(select count(*) from tupyo003 where kiho1=5 or kiho2=5 or kiho3=5) as 지효,
	(select count(*) from tupyo003 where kiho1=6 or kiho2=6 or kiho3=6) as 미나,
	(select count(*) from tupyo003 where kiho1=7 or kiho2=7 or kiho3=7) as 다현,
	(select count(*) from tupyo003 where kiho1=8 or kiho2=8 or kiho3=8) as 채영,
	(select count(*) from tupyo003 where kiho1=9 or kiho2=9 or kiho3=9) as 쯔위,
    (select 나연 + 정연 + 모모 + 사나 + 지효 + 미나 + 다현 + 채영 + 쯔위) as 총합, # 투표 총합 구하기
    (select count(*) from tupyo003 where kiho1 = kiho2 or kiho1 = kiho3 or kiho2 = kiho3) as 2중복, # 두명을 동일하게 찍은 사람 수 구하기
    (select count(*) from tupyo003 where kiho1 = kiho2 and kiho2 = kiho3) as 3중복; # 세명을 동일하게 찍은 사람 수 구하기
    

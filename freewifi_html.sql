drop table if exists freewifi_html; # 테이블이 있다면 지우기
create table freewifi_html( # 테이블 생성
	num int not null auto_increment primary key,
	addr varchar(50),
	latitude double,
    longitude double,
    distance double);
desc freewifi_html; # 테이블 구조 확인
select * from freewifi_html;
select count(*) from freewifi_html;

# freewifi 테이블에서 주소, 경도, 위도, 거리 가져오기
insert into freewifi_html(addr, latitude, longitude, distance)
select place_addr_road, latitude, longitude, (SQRT(POWER(latitude - 37.4207,2) + POWER(longitude - 127.2428,2))) from freewifi;

# update 테이블명 set 컬럼명 = replace(적용할 컬럼명, '원래의 문자열', '변경해야할 문자열');
update freewifi_html set addr = replace(addr, '"', ''); # 주소 칼럼의 큰 따옴표 없애기

update freewifi_html set addr = '부산광역시 부산진구 자유평화로7' where num=3; # 데이터 수정
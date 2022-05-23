use kopoctc;
set sql_safe_updates=0;
select b.id, (select name from hubo_table where id = b.id), count(b.id) from tupyo_table as b group by b.id order by b.id;


select b.id, (select name from hubo_table where id = b.id), count(b.id), round((count(b.id)/(select count(*) from tupyo_table))*100,0) from tupyo_table as b group by b.id order by b.id;
select age, count(age) from tupyo_table group by age order by age;

drop table if exists tupyo_table_calc; # 테이블이 있다면 지우기
create table tupyo_table_calc(age int);
insert into tupyo_table_calc(age) values(1), (2), (3), (4), (5), (6), (7), (8), (9);


desc tupyo_table;

select * from tupyo_table;
# 연령대별 분류
select id, age, count(age) from tupyo_table where id=2 group by age order by age;

# 2번 후보 연령대별 득표수
select a.age, ifnull((select count(*) from tupyo_table as t where t.age=a.age and t.id = 2 group by t.age), 0) as cnt from tupyo_table_calc as a group by age;
# 2번 후보 연령대별 득표수, 득표율
select a.age, ifnull((select count(*) from tupyo_table as t where t.age=a.age and t.id = 2 group by t.age), 0) as cnt, ifnull((select count(*) from tupyo_table as t where t.age=a.age and t.id = 2 group by t.age), 0)/(select count(*) from tupyo_table where id=2) as rate from tupyo_table_calc as a group by age;

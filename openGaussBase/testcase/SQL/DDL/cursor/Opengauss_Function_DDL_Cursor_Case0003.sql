--  @testpoint:cursor声明游标，以默认文本格式返回数据；

--前置条件
drop table if exists cur_test_03;
create table cur_test_03(c_id int,c_num int,c_name varchar(10),c_city varchar(10),c_add varchar(20));
insert into cur_test_03 values(1,18,'Allen','Beijing','AAAAABAAAAA'),(2,368,'Bob','Shanghai','AAAAACAAAAA'),
                           (3,59,'Cathy','Shenzhen','AAAAADAAAAA'),(4,96,'David','Suzhou','AAAAAEAAAAA'),
                           (5,17,'Edrwd','Fenghuang','AAAAAFAAAAA'),(6,253,'Fendi','Changsha','AAAAAGAAAAA');

start transaction;
cursor cursor3 for select * from cur_test_03 order by 1;
fetch from cursor3;
close cursor3;
end;

drop table cur_test_03;


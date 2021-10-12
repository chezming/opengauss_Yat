--  @testpoint:开启事务提取数据，参数为count，抓取随后的count行,count>0；

--前置条件
drop table if exists cur_test_87;
create table cur_test_87(c_id int,c_num int,c_name varchar(10),c_city varchar(10),c_add varchar(20));
insert into cur_test_87 values(1,18,'Allen','Beijing','AAAAABAAAAA'),(2,368,'Bob','Shanghai','AAAAACAAAAA'),
                           (3,59,'Cathy','Shenzhen','AAAAADAAAAA'),(4,96,'David','Suzhou','AAAAAEAAAAA'),
                           (5,17,'Edrwd','Fenghuang','AAAAAFAAAAA'),(6,253,'Fendi','Changsha','AAAAAGAAAAA');

--初始位置,count>0，无效数字，不在结果集的行数内
start transaction;
cursor cursor87 for select * from cur_test_87 order by 1;
fetch 8 from cursor87;
close cursor87;
end;


drop table cur_test_87;


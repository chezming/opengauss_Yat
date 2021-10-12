--  @testpoint:结合存储过程，显式游标，定义动态游标，提取同一游标到多个变量；

--前置条件
drop table if exists cur_test_114;
create table cur_test_114(c_id int,c_num int,c_name varchar(10),c_city varchar(10),c_add varchar(20));
insert into cur_test_114 values(1,18,'Allen','Beijing','AAAAABAAAAA'),(2,368,'Bob','Shanghai','AAAAACAAAAA'),
                           (3,59,'Cathy','Shenzhen','AAAAADAAAAA'),(4,96,'David','Suzhou','AAAAAEAAAAA'),
                           (5,17,'Edrwd','Fenghuang','AAAAAFAAAAA'),(6,253,'Fendi','Changsha','AAAAAGAAAAA');

--创建存储过程，显式游标的使用,提取同一游标到多个变量；
drop procedure if exists cursor_ftest_114;
create or replace procedure cursor_ftest_114()
as
declare
    fet_city1 varchar(10);
    fet_city2 varchar(10);
    fet_city3 varchar(10);
    type cursor_type is ref cursor;
    c114 cursor_type;
    sql_str varchar(100);
begin
    sql_str := 'select c_city from cur_test_114 where c_id >= 5;';
    open c114 for sql_str;
    fetch c114 into fet_city1;
    fetch c114 into fet_city2;
    fetch c114 into fet_city3;
    raise info 'fetch results1:%',fet_city1;
    raise info 'fetch results2:%',fet_city2;
    raise info 'fetch results3:%',fet_city3;
    close c114;
end;
/

call cursor_ftest_114();
drop table cur_test_114;
drop procedure cursor_ftest_114;

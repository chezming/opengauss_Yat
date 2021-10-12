--  @testpoint:结合存储过程，定义动态游标，打开动态游标，结合using动态指定命令；

--前置条件
drop table if exists cur_test_103;
create table cur_test_103(c_id int,c_num int,c_name varchar(10),c_city varchar(10),c_add varchar(20));
insert into cur_test_103 values(1,18,'Allen','Beijing','AAAAABAAAAA'),(2,368,'Bob','Shanghai','AAAAACAAAAA'),
                           (3,59,'Cathy','Shenzhen','AAAAADAAAAA'),(4,96,'David','Suzhou','AAAAAEAAAAA'),
                           (5,17,'Edrwd','Fenghuang','AAAAAFAAAAA'),(6,253,'Fendi','Changsha','AAAAAGAAAAA');

--创建存储过程，定义动态游标，结合using动态指定子句
drop procedure if exists cursor_ftest_103;
create or replace procedure cursor_ftest_103()
as
declare
    type cursor_type is ref cursor;
    c103 cursor_type;
    sql_str varchar(100);
begin
    sql_str := 'select c_name from cur_test_103 where c_id <= :num;';
    open c103 for sql_str using 5;
    close c103;
end;
/

call cursor_ftest_103();
drop table cur_test_103;
drop procedure cursor_ftest_103;

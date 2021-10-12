--  @testpoint:结合存储过程，显式游标，定义静态游标，提取不同名游标，合理报错；

--前置条件
drop table if exists cur_test_105;
create table cur_test_105(c_id int,c_num int,c_name varchar(10),c_city varchar(10),c_add varchar(20));
insert into cur_test_105 values(1,18,'Allen','Beijing','AAAAABAAAAA'),(2,368,'Bob','Shanghai','AAAAACAAAAA'),
                           (3,59,'Cathy','Shenzhen','AAAAADAAAAA'),(4,96,'David','Suzhou','AAAAAEAAAAA'),
                           (5,17,'Edrwd','Fenghuang','AAAAAFAAAAA'),(6,253,'Fendi','Changsha','AAAAAGAAAAA');

--开启事务，定义一个外部游标
start transaction;
cursor c105 for select * from cur_test_105;

--创建存储过程，显式游标的使用,提取外部不同名游标；
drop procedure if exists cursor_ftest_105;
create or replace procedure cursor_ftest_105()
as
declare
    fet_name varchar(10);
begin
    open c105;
    fetch c105 into fet_name;
    raise info 'fetch results:%',fet_name;
    close c105;
end;
/

end;

call cursor_ftest_105();
drop table cur_test_105;

-- @describe:存储过程中定义一个record类型

--创建存储过程
CREATE OR REPLACE procedure pro_record_002() AS
DECLARE
   type rec_type is record (name varchar2(100),epno int);
   employer rec_type;
BEGIN     
     employer.name := 'WARD';
     employer.epno = 18;
     raise info 'employer name:%,epno:%',employer.name,employer.epno;
END;
/

--调用存储过程
call pro_record_002();

--删除存储过程
drop procedure pro_record_002;

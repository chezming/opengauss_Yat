--  @testpoint:函数中不涉及对临时表的相关操作,使用DROP FUNCTION删除函数
--建表
DROP  TABLE IF EXISTS sales4;
create  table sales4(itemno integer,quantity integer,price numeric);
insert into sales4 values (100,15,11.2),(101,22,12.3);
select * from sales4;

--创建函数，return子句查询表的信息
DROP FUNCTION if EXISTS extended_sales4(p_itemno IN integer);
CREATE FUNCTION extended_sales4(p_itemno IN integer)RETURNS TABLE(quantity integer, total numeric) AS $$
BEGIN
RETURN QUERY SELECT sales4.quantity, sales4.quantity * sales4.price FROM sales4
WHERE itemno = p_itemno;
END;
$$ LANGUAGE plpgsql;
/
call extended_sales4(101);


drop FUNCTION extended_sales4(p_itemno IN integer) ;
drop table sales4;

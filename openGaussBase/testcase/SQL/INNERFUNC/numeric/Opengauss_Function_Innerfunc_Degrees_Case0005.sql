-- @testpoint: degrees函数入参为指定类型的边界值
drop table if exists tb1;
create table tb1 (clo1 bigint,clo2 bigint);
select degrees(clo1),degrees(clo2) from tb1;
drop table if exists tb1;
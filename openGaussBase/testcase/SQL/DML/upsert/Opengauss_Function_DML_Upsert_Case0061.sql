--  @testpoint:使用insert...nothing语句，插入两条数据，第一条数据主键列已存在，其他列数据不存在；第二条数据主键列已存在，其他列数据不存在；直接返回
--预置条件enable_upsert_to_merge为off
drop table if exists products_c5;
--建表，指定一列是主键
CREATE TABLE products_c5 (
    product_no integer PRIMARY KEY,
    name text,
    price numeric
);
--常规插入一条数据
insert into  products_c5 values(10,'grains',5.5);
select * from  products_c5;
--使用insert...nothing语句,直接返回，不更改已有数据
insert into products_c5 values(10,'grains1',5.25),(10,'grains2',5.55) on DUPLICATE key update nothing;
select * from  products_c5;
drop table products_c5;
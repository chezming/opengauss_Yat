--  @testpoint:冲突后使用insert...update并添加EXCLUDED关键字，执行同样语句两次
----预置条件enable_upsert_to_merge为off
drop table if exists products_b3;
--建表，指定一列是主键
CREATE TABLE products_b3 (
    product_no integer PRIMARY KEY,
    name text,
    price numeric
);
--常规插入一条语句
insert into  products_b3 values(01,'grains',5.5);
select * from products_b3;
--使用insert...update语句插入一条数据，主键不重复，插入数据成功
insert into  products_b3 values(02,'grains',5.5) on DUPLICATE key update name=EXCLUDED.name, price=EXCLUDED.price;
select * from products_b3;
--再次执行以上语句，数据未发生变化
insert into  products_b3 values(02,'grains',5.5) on DUPLICATE key update name=EXCLUDED.name, price=EXCLUDED.price;
select * from  products_b3;
drop table products_b3;
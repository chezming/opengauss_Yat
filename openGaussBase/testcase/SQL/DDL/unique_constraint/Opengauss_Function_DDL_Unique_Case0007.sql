-- @testpoint: 创建约束，约束名存在，合理报错
-- @modify at: 2020-11-23
--建表，报错
drop table if exists test_unique_constraint007;
create table test_unique_constraint007 (id_p int not null, lastname varchar(255) not null, firstname varchar(255),
address varchar(255), city varchar(255),
constraint uc_personid unique (id_p),constraint uc_personid unique (lastname));
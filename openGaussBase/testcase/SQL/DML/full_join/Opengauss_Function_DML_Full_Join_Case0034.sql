-- @testpoint:同一张表使用full join查询，与CASE when ..then结合，条件为条件为in，合理报错
-- @modify at: 2020-11-13
--建表
drop table if exists customer;
CREATE TABLE customer
(CUSTOMER_ID integer,
 CUST_FIRST_NAME  VARCHAR(20) NOT NULL,
 CUST_LAST_NAME   VARCHAR(20) NOT NULL,
 CREDIT_LIMIT INTEGER
);
--插入数据
insert into customer values (1, 'li', 'adjani', 100);
insert into customer values (2, 'li', 'alexander', 2000);
insert into customer values (3, 'li', 'altman', 5000);
--查询，合理报错，ERROR:  FULL JOIN is only supported with merge-joinable or hash-joinable join conditions
SELECT * FROM customer t1 full join customer t2 on
CASE t1.credit_limit
WHEN 100 THEN 'Low'
WHEN 5000 THEN 'High'
WHEN 2000 THEN 'Medium'
END between 123 and 456;
--删表
drop table if exists customer;
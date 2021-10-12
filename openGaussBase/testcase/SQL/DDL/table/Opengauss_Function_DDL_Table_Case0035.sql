-- @testpoint: 设置针对每个字段的统计收集目标并添加和删除多列统计信息声明

drop table if exists analyze_table_001;
create table analyze_table_001(c_id int,name varchar2(10),time date ,sex clob);
insert into analyze_table_001 values(1,'m',to_date('2018','yyyy'),'mmmmmm');
insert into analyze_table_001 values(2,'mm',to_date('2018','yyyy'),'mmmmmm');
insert into analyze_table_001 values(3,'mmm',to_date('2018','yyyy'),'mmmmmm');
insert into analyze_table_001 values(4,'mmmm',to_date('2018','yyyy'),'mmmmmm');
alter table analyze_table_001 ALTER COLUMN name SET STATISTICS PERCENT 50;
alter table analyze_table_001 ADD  STATISTICS ((c_id, name));
alter table analyze_table_001 DELETE STATISTICS ((c_id, name));
analyze   analyze_table_001;
drop table if exists analyze_table_001;
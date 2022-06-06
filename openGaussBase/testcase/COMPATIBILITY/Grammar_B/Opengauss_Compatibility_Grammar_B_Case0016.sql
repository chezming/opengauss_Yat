-- @testpoint: 查询表数据，使用distinctrow
--step1:创建普通行存表;expect:成功
drop table if exists tb_b_grammar_0016;
create table tb_b_grammar_0016(id int,name varchar(20),age int,stuno int)engine =INNODB;

--step2:插入数据;expect:成功
insert tb_b_grammar_0016 value(1,'zhangsan',18,23);
insert tb_b_grammar_0016 value(2,'lisi',19,24);
insert tb_b_grammar_0016 value(3,'wangwu',18,25);
insert tb_b_grammar_0016 value(4,'zhaoliu',18,26);
insert tb_b_grammar_0016 value(5,'zhangsan',18,27);
insert tb_b_grammar_0016 value(6,'wangwu',20,28);

--step3:使用distinctrow,对一列去重;expect:成功(4 rows)
select distinctrow name from tb_b_grammar_0016;
select distinctrow name from tb_b_grammar_0016 order by name;

--step4:使用distict,对一列去重;expect:成功(4 rows),结果和step3一样
select distinct name from tb_b_grammar_0016;

--step5:使用distinctrow,对2列去重;expect:成功5 rows
select distinctrow name,age from tb_b_grammar_0016;

--step6:使用distinct,对2列去重5 rows;expect:成功
select distinct name,age from tb_b_grammar_0016;

--step7:distinctrow所有列去重;expect:成功6 rows
select distinctrow * from tb_b_grammar_0016;

--step8:再次插入数据;expect:成功
insert tb_b_grammar_0016 value(1,'zhangsan',18,23);

--step9:所有列去重;expect:成功6 rows
select distinctrow * from tb_b_grammar_0016;

--step10:清理环境;expect:成功
drop table if exists tb_b_grammar_0016;


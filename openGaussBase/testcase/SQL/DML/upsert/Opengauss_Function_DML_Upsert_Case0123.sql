--  @testpoint:测试excluded作为保留关键字是否存入pg_get_keywords()系统表
select word from pg_get_keywords() where word ='excluded';
--  @testpoint:删除词典测试
--查询词典，词典不存在
select dictname from PG_TS_DICT where dictname ='my_dictionary';
--删除不存在的词典，省略if exists选项，合理报错
drop TEXT SEARCH DICTIONARY my_dictionary;
--删除不存在的词典，添加if exists选项，发出notice
drop TEXT SEARCH DICTIONARY if exists my_dictionary;
--删除不存在的词典，添加if exists cascade选项，发出notice
drop TEXT SEARCH DICTIONARY if exists my_dictionary cascade;
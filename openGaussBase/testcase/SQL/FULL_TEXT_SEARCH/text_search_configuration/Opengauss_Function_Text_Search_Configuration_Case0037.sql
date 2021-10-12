--  @testpoint:删除文本搜索配置，用户权限测试
--sysadmin用户创建文本搜索配置
drop TEXT SEARCH CONFIGURATION if exists ngram2 cascade;
CREATE TEXT SEARCH CONFIGURATION ngram2 (parser=ngram) WITH (gram_size = 2, grapsymbol_ignore = false);
--删除文本搜索配置（sysadmin用户和所有者为同一个用户，执行删除操作)
drop TEXT SEARCH CONFIGURATION ngram2 cascade;


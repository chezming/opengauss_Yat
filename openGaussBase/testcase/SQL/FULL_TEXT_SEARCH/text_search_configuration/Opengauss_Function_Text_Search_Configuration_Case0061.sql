--  @testpoint:文本搜索配置token_type测试
--创建文本搜索配置，解析器为默认pg_catalog.default
DROP TEXT SEARCH CONFIGURATION if exists english2 cascade;
CREATE TEXT SEARCH CONFIGURATION english2 (parser=default);
--创建simple字典
DROP TEXT SEARCH DICTIONARY IF EXISTS pg_dict cascade;
CREATE TEXT SEARCH DICTIONARY pg_dict (TEMPLATE = Simple);
--增加文本搜索配置字串类型映射，token为uint
ALTER TEXT SEARCH CONFIGURATION english2 ADD MAPPING FOR uint WITH pg_dict;
--使用文本检索函数对所创建的词典配置english2进行测试
SELECT ts_debug('english','1234');
SELECT ts_debug('1234');
--删除文本搜索配置
DROP TEXT SEARCH CONFIGURATION english2 cascade;
--删除词典
DROP TEXT SEARCH DICTIONARY pg_dict cascade;
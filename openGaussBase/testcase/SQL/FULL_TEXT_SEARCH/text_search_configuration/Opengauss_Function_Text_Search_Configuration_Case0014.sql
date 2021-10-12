--  @testpoint:修改文本搜索配置字串类型语法测试，字串类型与解析器不对应
--创建文本搜索配置
DROP TEXT SEARCH CONFIGURATION if exists english2;
CREATE TEXT SEARCH CONFIGURATION english2 (parser=default);
--创建simple字典
DROP TEXT SEARCH DICTIONARY IF EXISTS pg_dict;
CREATE TEXT SEARCH DICTIONARY pg_dict (TEMPLATE = Simple);
--增加文本搜索配置字串类型映射
ALTER TEXT SEARCH CONFIGURATION english2 ADD MAPPING FOR numword WITH simple,french_stem;
--修改文本搜索配置字串类型(字串类型与解析器不对应)，合理报错
ALTER TEXT SEARCH CONFIGURATION english2 ALTER MAPPING FOR alnum WITH simple,french_stem;
--查询文本搜索配置相关信息
SELECT cfgname,cfoptions  FROM PG_TS_CONFIG where cfgname='ngram2';
--删除文本搜索配置
DROP TEXT SEARCH CONFIGURATION english2;
--删除字典
DROP TEXT SEARCH DICTIONARY pg_dict;

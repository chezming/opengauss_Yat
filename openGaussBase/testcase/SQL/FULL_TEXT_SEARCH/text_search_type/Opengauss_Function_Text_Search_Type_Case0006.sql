--  @testpoint:测试to_tsvector函数对单词进行规范化处理
--testpoint1:大写转小写，删除单词结尾s
SELECT to_tsvector('english', 'The Fat Rats');
--testpoint2:to_tsquery( 'postgres:*' )以postgr开头的任意单词，这样就匹配postgraduate
SELECT to_tsvector( 'postgraduate' ) @@ to_tsquery( 'postgres:*' ) AS RESULT;
--testpoint3:to_tsquery对单词规范化处理,大写转小写，删除结尾s
SELECT to_tsquery('Fat:ab & Cats');
--testpoint4:::tsvector函数未对单词进行规范化，因此返回f
SELECT 'fat cats ate fat rats'::tsvector @@ to_tsquery('fat & rat');
--清理环境 no need to clean


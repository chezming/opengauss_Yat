-- @testpoint: opengauss比较操作符<>，文本搜索类型
-- 文本搜索类型
SELECT 'a fat cat sat on a mat and ate a fat rat'::tsvector <> 'a'::tsvector;
SELECT 'b fat cat sat on a mat and ate a fat rat'::tsvector <> 'a'::tsvector;
SELECT 'b fat cat sat on a mat and ate a fat rat'::tsvector <> 'c'::tsvector;
SELECT 'fat & rat'::tsquery <> 'gat & rat'::tsquery;
SELECT 'fat & rat'::tsquery <> 'aat & rat'::tsquery;
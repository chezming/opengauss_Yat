--  @testpoint:匹配算子@@测试（返回true)
--tsvector(document)匹配到一个tsquery(query)(模糊匹配)
SELECT 'a fat cat sat on a mat and ate a fat rat'::tsvector @@ 'cat & rat'::tsquery AS RESULT;
--tsvector(document)匹配到一个tsquery(query)(全部匹配)
SELECT 'cat rat'::tsvector @@ 'cat & rat'::tsquery AS RESULT;
--顺序颠倒
SELECT 'cat & rat'::tsquery @@ 'a fat cat sat on a mat and ate a fat rat'::tsvector  AS RESULT;
SELECT 'cat & rat'::tsquery @@ 'cat & rat'::tsvector AS RESULT;
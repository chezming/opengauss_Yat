-- @testpoint: 文本比较操作符 = ，检查两个tsquery类型的词汇是否相等2

select to_tsvector('fat cats ate ratsr') =  to_tsvector('fat cats ate rats') as result;
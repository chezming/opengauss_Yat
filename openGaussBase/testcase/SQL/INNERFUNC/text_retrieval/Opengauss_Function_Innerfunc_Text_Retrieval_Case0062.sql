-- @testpoint: opengauss内置函数length，当文本中含有空格时，获取tsvector类型单词数

select length($$the lexeme '    ' contains spaces$$::tsvector);
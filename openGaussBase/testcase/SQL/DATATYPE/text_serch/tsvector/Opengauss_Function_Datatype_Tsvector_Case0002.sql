-- @testpoint: 词条中使用引号，可以使用双$$符号作为标记

select $$the lexeme '    ' contains spaces$$::tsvector;
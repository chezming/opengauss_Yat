--  @testpoint:default类型的解析器添加with选项，合理报错
DROP TEXT SEARCH CONFIGURATION if exists english2;
CREATE TEXT SEARCH CONFIGURATION english2 (parser=default) WITH (gram_size = 2, punctuation_ignore= y,grapsymbol_ignore = n);
-- @testpoint: encode(data bytea, format text)将二进制数据编码为文本数据
SELECT encode('011011', 'base64');
SELECT encode('test', 'base64');


-- @testpoint: overlay函数入参为时间类型字符
SELECT overlay('2008-08-08 08:08:08' placing 'world' from 2 for 10 );
SELECT overlay('2020/7/24 08:08:08' placing '09:09:09' from 2 for 13 );
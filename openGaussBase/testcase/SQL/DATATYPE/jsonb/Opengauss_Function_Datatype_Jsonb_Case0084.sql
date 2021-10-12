-- @testpoint: json额外支持操作函数：json_to_recordset（对array-json中的每一个object-json执行上述json_to_record的操作，当入参不合理时，合理报错）

--合理入参
select * from json_to_recordset('[{"a":1,"b":"foo","c":"bar"}]',true) as x(a int, b text, d text);
select * from json_to_recordset('[{"a":1,"b":"foo","d":false}]',false) as x(a int, b text, c boolean);
select * from json_to_recordset('[{"a":1,"b":"foo","d":false},{"a":2,"b":"bar","c":true}]',false) as x(a int, b text, c boolean);

--不合理入参
select * from json_to_recordset('"a"',true) as x(a int, b text, c boolean);
select * from json_to_recordset('1,1.2',true) as x(a int, b text, c boolean);
select * from json_to_recordset('null',true) as x(a int, b text, c boolean);
select * from json_to_recordset('false',true) as x(a int, b text, c boolean);
select * from json_to_recordset('"a",1,"b",1.2,"c",true,"d",null',true) as x(a int, b text, c boolean);
select * from json_to_recordset('{"a":"wahaha","b":138,"c":"bar"}',true) as x(a int, b text, d text);
select * from json_to_recordset('[{"a":1,"b":"foo","d":false},{"a":"qw","b":"bar","c":true}]',false) as x(a int, b text, c boolean);
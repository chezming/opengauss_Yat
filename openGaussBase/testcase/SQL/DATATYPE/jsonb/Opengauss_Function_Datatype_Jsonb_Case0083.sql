-- @testpoint: json额外支持操作函数：json_to_record（从一个object-json构建一个任意的记录，当入参不合理时，合理报错）

--合理入参
select * from json_to_record('{"a":1,"b":"foo","c":"bar"}',true) as x(a int, b text, d text);
select * from json_to_record('{"a":"wahaha","b":138,"c":"bar"}',true) as x(a int, b text, d text);
select * from json_to_record('{"a":1,"b":"foo","d":false}',false) as x(a int, b text, c boolean);
select * from json_to_record('{"a":1,"b":"foo","c":"false"}',false) as x(a int, b text, c varchar);

--不合理入参
select * from json_to_record('{"a":"wahaha","b":138,"c":"bar"}',true) as x(a int, b text, d text);
select * from json_to_record('[{"a":1,"b":"foo","d":false},{"a":2,"b":"bar","c":true}]',false) as x(a int, b text, c boolean);
select * from json_to_record('"a"',true) as x(a int, b text, c boolean);
select * from json_to_record('1,1.2',true) as x(a int, b text, c boolean);
select * from json_to_record('null',true) as x(a int, b text, c boolean);
select * from json_to_record('false',true) as x(a int, b text, c boolean);
select * from json_to_record('"a",1,"b",1.2,"c",true,"d",null',true) as x(a int, b text, c boolean);

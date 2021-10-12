-- @testpoint: json额外支持操作函数：json_build_object（从一个可变参数列表构造出一个JSON对象，当入参不合理时，合理报错）

--合理入参
select json_build_object('a',1,'b',1.2,'c',true,'d',null,'e','false');
select json_build_object('a',1,'b',1.2,'c',true,'d',null,'{"x": 3, "y": [1,2,3]}','false');
select json_build_object('a',1,'b',1.2,'c',true,'""',null,'{"x": 3, "y": [1,2,3]}','');
select json_build_object('[1,"b",1.2,"c",true,"d"]',null,'1236.8','{"x": 3, "y": [1,2,3]}');

--不合理入参
select json_build_object(null,'a',1,'b',1.2,'c',true,'d','e',json '{"x": 3, "y": [1,2,3]}');
select json_build_object('a',1,'b',1.2,'c',true,'',null,'{"x": 3, "y": [1,2,3]}','');
select json_build_object(json'[1,"b",1.2,"c",true,"d"]',null,'1236.8','{"x": 3, "y": [1,2,3]}');
select json_build_object('[1,"b",1.2,"c",true,"d"]',null,'1236.8','{"x": 3, "y": [1,2,3]}','false');
select json_build_object('a',1,'b',1.2,'c','true','d',"null",'1236.8','{"x": 3, "y": [1,2,3]}','');
select json_build_object(1,json'b','[1.2,"c",true,"d"]',null,'+1236.8','{"x": 3, "y": [1,2,3]}','');

--返回结果类型校验：object-json
select pg_typeof(json_build_object('a',1,'b',1.2,'c',true,'d',null,'e','false'));
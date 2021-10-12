-- @testpoint:数据类型转换至VARCHAR2（多次转换）；
drop table if exists object_identifier_009;
CREATE  TABLE object_identifier_009(
	c1 OID,
	c2 CID,
	c3 XID,
	c4 TID,
	c5 REGCONFIG,
	c6 REGDICTIONARY,
	c7 REGOPER,
	c8 REGOPERATOR,
	c9 REGPROC,
	c10 REGPROCEDURE,
	c11 REGCLASS,
	c12 REGTYPE
);
alter table object_identifier_009 alter column c1 TYPE VARCHAR2(200);
alter table object_identifier_009 alter column c2 TYPE VARCHAR2(200);
alter table object_identifier_009 alter column c3 TYPE VARCHAR2(200);
alter table object_identifier_009 alter column c4 TYPE VARCHAR2(200);
alter table object_identifier_009 alter column c5 TYPE VARCHAR2(200);
alter table object_identifier_009 alter column c6 TYPE VARCHAR2(200);
alter table object_identifier_009 alter column c7 TYPE VARCHAR2(200);
alter table object_identifier_009 alter column c8 TYPE VARCHAR2(200);
alter table object_identifier_009 alter column c9 TYPE VARCHAR2(200);
alter table object_identifier_009 alter column c10 TYPE VARCHAR2(200);
alter table object_identifier_009 alter column c11 TYPE VARCHAR2(200);
alter table object_identifier_009 alter column c12 TYPE VARCHAR2(200);
select * from object_identifier_009;
drop table if exists object_identifier_009;
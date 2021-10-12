-- @testpoint:数据表建立及查询；
drop table if exists object_identifier_001;
CREATE  TABLE object_identifier_001(
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
select * from object_identifier_001;
drop table if exists object_identifier_001;
-- @testpoint: PostGIS功能覆盖,获取geogA和geogB两个区域的相交部分,ST_Intersection

--step1:创建表   expect:成功
drop table if exists t_postgis_0023_01;
drop table if exists t_postgis_0023_02;
drop table if exists t_postgis_0023_03;

create table t_postgis_0023_01 (smgeometry1 geometry(MultiLineString,4490),
                                smgeometry2 geometry(MultiPolygon,4490));
create table t_postgis_0023_02 (smgeometry1 geometry(LineString,4490),
                                smgeometry2 geometry(Polygon,4490));
create table t_postgis_0023_03 (smgeometry1 geometry(MultiPoint,4490),
                                smgeometry2 geometry(Point,4490));

--step2:插入对应数据   expect:成功
insert into t_postgis_0023_01 values(ST_GeomFromText('MultiLineString((0 0,1 1,1 2),(2 1,3 2,5 4))',4490),
ST_GeomFromText('MultiPolygon(((0 0,4 0,4 4,0 4,0 0),(1 1,2 1,2 2,1 2,1 1)), ((-1 -1,-1 -2,-2 -2,-2 -1,-1 -1)))',4490));
insert into t_postgis_0023_02 values(ST_GeomFromText('LineString(0 0,1 1,1 2)',4490),
ST_GeomFromText('Polygon((-1 -1, 3 1, 2 2, 0 2,-1 -1))',4490));
insert into t_postgis_0023_03 values(ST_GeomFromText('MULTIPOINT((2 1),(5 3))',4490),
ST_GeomFromText('point(2 2)',4490));

--step3:结合表查看数据   expect:成功
--获取线线之间相交的部分
select ST_AsEWKT(ST_Intersection(t1.smgeometry1,t2.smgeometry1)) from t_postgis_0023_01 t1,t_postgis_0023_02 t2;
--获取面面之间相交的部分
select ST_AsEWKT(ST_Intersection(t1.smgeometry2,t2.smgeometry2)) from t_postgis_0023_01 t1,t_postgis_0023_02 t2;
--获取线面之间相交的部分
select ST_AsEWKT(ST_Intersection(t1.smgeometry1,t2.smgeometry2)) from t_postgis_0023_01 t1,t_postgis_0023_02 t2;
select ST_AsEWKT(ST_Intersection(t1.smgeometry2,t2.smgeometry1)) from t_postgis_0023_01 t1,t_postgis_0023_02 t2;
--获取点线之间相交的部分
select ST_AsEWKT(ST_Intersection(t1.smgeometry1,t3.smgeometry1)) from t_postgis_0023_01 t1,t_postgis_0023_03 t3;
--获取点面之间相交的部分
select ST_AsEWKT(ST_Intersection(t3.smgeometry2,t2.smgeometry2)) from t_postgis_0023_02 t2,t_postgis_0023_03 t3;

--step4:清理环境   expect:成功
drop table t_postgis_0023_01 cascade;
drop table t_postgis_0023_02 cascade;


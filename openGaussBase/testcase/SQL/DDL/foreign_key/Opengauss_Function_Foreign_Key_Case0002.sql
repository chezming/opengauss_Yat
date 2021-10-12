-- @testpoint: 测试在不同父表约束下建立外键，合理报错

drop table if exists student;
drop table if exists teacher;
create table teacher
(
    t_id1 int primary key,
    t_id2 int unique,
    t_id3 int default 0,
    t_id4 varchar(20) check (t_id4 is not null),
    t_id5 varchar(20) not null,
    t_id6 int
);
create table student
(
    id int primary key,
    t_id1 int,
    t_id2 int,
    t_id3 int,
    t_id4 varchar(20),
    t_id5 varchar(20),
    t_id6 int
);
alter table student add constraint fk_student_tid1 foreign key (t_id1) references teacher(t_id1);
alter table student add constraint fk_student_tid2 foreign key (t_id2) references teacher(t_id2);
alter table student add constraint fk_student_tid3 foreign key (t_id3) references teacher(t_id3);
alter table student add constraint fk_student_tid4 foreign key (t_id4) references teacher(t_id4);
alter table student add constraint fk_student_tid5 foreign key (t_id5) references teacher(t_id5);
alter table student add constraint fk_student_tid6 foreign key (t_id6) references teacher(t_id6);
drop table if exists student;
drop table if exists teacher;

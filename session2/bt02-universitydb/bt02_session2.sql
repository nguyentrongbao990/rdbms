create database "UniversityDB";
create schema university;
create table university."Students"(
	student_id int generated always as identity primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	birth_day date,
	email varchar(255) not null unique
);
create table university.courses(
	course_id int generated always as identity primary key,
	course_name varchar(100) not null,
	credits int
);
create table university.enrollments(
	enrollment_id int generated always as identity primary key,
	student_id int references university."Students"(student_id),
	course_id int references university.courses(course_id),
	enroll_date date
);
-- xem danh sach database
select datname from pg_database order by datname;
-- xem danh sach schema
select schema_name
from information_schema.schemata
order by schema_name;
-- xem cau truc bang Students
select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema = 'university' and table_name = 'Students'
order by ordinal_position;
-- xem cau truc bang Courses
select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema = 'university' and table_name = 'courses'
order by ordinal_position;
-- xem cau truc bang enrollments
select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema = 'university' and table_name = 'enrollments'
order by ordinal_position;
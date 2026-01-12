create table students(
	student_id int generated always as identity primary key,
	name varchar(200) not null,
	dob date not null
);
create table courses(
	course_id int generated always as identity primary key,
	course_name varchar(200) not null,
	credits numeric(10,2) not null check (credits>=0)
);
create table enrollments (
	enrollment_id int generated always as identity primary key,
	student_id int,
	course_id int,
	grade varchar(2) not null
);
create schema elearning;
create table elearning."Students"(
	student_id int generated always as identity primary key,
	first_name varchar(50) not null,
	last_name varchar (50) not null,
	email varchar(255) not null unique
);
create table elearning."Instructors"(
	instructor_id int generated always as identity primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	email varchar(255) not null unique
);
create table elearning."Courses"(
	course_id int generated always as identity primary key,
	course_name varchar(100) not null,
	instructor_id int references elearning."Instructors"(instructor_id)
);
create table elearning."Enrollments"(
	enrollment_id int generated always as identity primary key,
	student_id int references elearning."Students"(student_id),
	course_id int references elearning."Courses"(course_id),
	enroll_date date not null
);
create table elearning."Assignments"(
	assignment_id int generated always as identity primary key,
	course_id int references elearning."Courses"(course_id),
	title varchar(100) not null,
	due_date date not null
);
create table elearning."Submissions"(
	submission_id int generated always as identity primary key,
	assignment_id int references elearning."Assignments"(assignment_id),
	student_id int references elearning."Students"(student_id),
	submission_date date not null,
	grade numeric(5,2) check(grade >= 0 and grade <= 100)
);
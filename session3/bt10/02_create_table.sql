create table Departments(
	department_id int generated always as identity primary key,
	department_name varchar(100) not null
);
create table employees(
	emp_id int generated always as identity primary key,
	name varchar(200) not null,
	dob date not null,
	department_id int references departments(department_id)
);
create table projects(
	project_id int generated always as identity primary key,
	project_name varchar(200) not null,
	start_date date default current_date,
	end_date date check (end_date > start_date)
);
create table EmployeeProjects(
	emp_id int references employees(emp_id),
	project_id int references projects(project_id)
);
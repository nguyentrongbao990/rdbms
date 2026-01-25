create schema bt05;
set search_path to bt05;
CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  department VARCHAR(50),
  salary NUMERIC(10,2),
  bonus NUMERIC(10,2) DEFAULT 0,
  status TEXT
);

INSERT INTO employees (name, department, salary) VALUES
('Nguyen Van A', 'HR', 4000),
('Tran Thi B', 'IT', 6000),
('Le Van C', 'Finance', 10500),
('Pham Thi D', 'IT', 8000),
('Do Van E', 'HR', 12000);

create or replace procedure update_employees_status(
	p_emp_id int,
	out p_status text
)
language plpgsql
as $$
declare
	v_salary numeric(10,2);
begin
	select e.salary
	into v_salary
	from employees e
	where e.id = p_emp_id;

	if not found then
		raise exception 'Employee not found';
	end if;	

	if v_salary <5000 then
		p_status := 'Junior';
	elsif v_salary <= 10000 then
    	p_status := 'Mid-level';
  	else
    	p_status := 'Senior'; 
	end if;

	update employees e
  	set status = p_status
  	where e.id = p_emp_id;
end;
$$;

CALL update_employees_status(1, NULL);   -- 4000 -> Junior
CALL update_employees_status(2, NULL);   -- 6000 -> Mid-level
CALL update_employees_status(3, NULL);   -- 10500 -> Senior
CALL update_employees_status(999, NULL); -- lỗi Employee not found

SELECT id, name, salary, status
FROM employees
ORDER BY id;
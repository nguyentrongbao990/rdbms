create schema bt03;
set search_path to bt03;
-- tao bang
create table employees(
	emp_id serial primary key,
	emp_name varchar(100),
	job_level int,
	salary numeric
);
--dư liệu mẫu:
INSERT INTO employees(emp_name, job_level, salary) VALUES
( 'An',   1, 1000.00),
( 'Binh', 2, 2000.00),
( 'Chi',  3, 3000.00);

/* yêu cầu:Tạo Procedure adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC) để:
Nhận emp_id của nhân viên
Cập nhật lương theo quy tắc trên
Trả về p_new_salary (lương mới) sau khi cập nhật*/
create or replace procedure adjust_salary(
	p_emp_id int,
	out p_new_salary numeric
)
language plpgsql
as $$
declare
	v_level int;
	v_factor numeric;
begin
	--Lấy job_level của nhân viên vào v_level
	select job_level into v_level
	from employees
	where emp_id = p_emp_id;
	
	IF NOT FOUND THEN
  		RAISE EXCEPTION 'Nhân viên không tồn tại';
	END IF;
	--IF/ELSIF theo v_level để set v_factor = 1.05 / 1.10 / 1.15
	if v_level = 1 then v_factor := 1.05;
	elsif v_level= 2 then v_factor := 1.10;
	elsif v_level =3 then v_factor := 1.15;
	else raise exception 'Job level khong hop le';
	end if;
	--update
	update employees
	set salary = salary * v_factor
	where emp_id= p_emp_id
	returning salary into p_new_salary;
end;
$$;
-- thực thi thử
call adjust_salary(3,null); --3967.50
CALL adjust_salary(1,null); --1050.00
CALL adjust_salary(999,null); --Nhân viên không tồn tại
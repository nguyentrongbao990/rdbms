set search_path to bt05;
create or replace procedure calculate_bonus (
	p_emp_id int,
	p_percent numeric,
	out p_bonus numeric
)
language plpgsql
as $$
declare
	v_salary numeric(10,2);
begin
	select e.salary into v_salary
	from employees e
	where e.id = p_emp_id;

	if not found then
		raise exception 'Employee not found';
	end if;

	if p_percent <=0
		then p_bonus:=0;
	else p_bonus := v_salary * p_percent / 100;
	end if;

	update employees
	set bonus = p_bonus
	where id = p_emp_id;
	
end;
$$;

call calculate_bonus(2,10,null);
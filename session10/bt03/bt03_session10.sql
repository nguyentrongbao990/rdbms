create schema bt03;
set search_path to bt03;
create table employees (
	id bigserial primary key,
	name varchar (100) not null,
	position varchar(100) not null,
	salary numeric(10,2) not null check(salary>0)
);
create table employees_log (
  log_id bigserial primary key,
  employee_id bigint,
  operation text not null,                -- 'INSERT' | 'UPDATE' | 'DELETE'
  old_data jsonb,
  new_data jsonb,
  change_time timestamptz not null default now()
);

create or replace function update_employees_log()
returns trigger
language plpgsql
as $$
begin
	if tg_op = 'INSERT' then
		insert into employees_log(employee_id,operation,old_data,new_data) values
		(new.id,tg_op,null,to_jsonb(new));
		return new;
	elsif tg_op = 'UPDATE' then
		insert into employees_log(employee_id,operation,old_data,new_data) values
		(new.id,tg_op,to_jsonb(old),to_jsonb(new));
		return new;
	elsif tg_op = 'DELETE' then
		insert into employees_log(employee_id,operation,old_data,new_data) values
		(new.id,tg_op,to_jsonb(old),null);
		return old;
	end if;
	return null;
end;
$$;
drop trigger if exists trg_employees_audit on employees;

create trigger trg_employees_audit
after insert or update or delete on employees
for each row
execute function update_employees_log();

--test
-- insert
insert into employees(name, position, salary)
values ('an', 'dev', 1000.00);

-- update
update employees
set salary = 1500.00, position = 'senior dev'
where name = 'an';

-- delete
delete from employees
where name = 'an';

-- xem log
select log_id, employee_id, operation, old_data, new_data, change_time
from employees_log
order by log_id;


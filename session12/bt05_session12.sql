create schema bt05;
set search_path to bt05;

-- (1) bang nhan vien
create table employees (
  emp_id serial primary key,
  name varchar(50),
  position varchar(50)
);

-- (2) bang ghi log khi cap nhat nhan vien
create table employee_log (
  log_id serial primary key,
  emp_name varchar(50),
  action_time timestamp
);


-- function: moi lan update employees thi ghi log vao employee_log
create or replace function fn_log_employee_update()
returns trigger
language plpgsql
as $$
begin
  -- (1) neu update nhung khong thay doi gi (vd set giong y cu) thi khong ghi log
  if new is not distinct from old then
    return new;
  end if;

  -- (2) ghi log: ten nhan vien va thoi gian cap nhat
  insert into employee_log (emp_name, action_time)
  values (new.name, now());

  return new;
end;
$$;

create trigger trg_employees_after_update_log
after update on employees
for each row
execute function fn_log_employee_update();

-- them nhan vien mau
insert into employees (name, position)
values
  ('nguyen van a', 'staff'),
  ('tran thi b', 'intern');

select * from employees order by emp_id;

-- cap nhat thong tin nhan vien (vi du doi position)
update employees
set position = 'manager'
where emp_id = 1;

-- kiem tra bang log (phai co 1 dong moi)
select * from employee_log order by log_id;

-- xem lai employees
select * from employees order by emp_id;


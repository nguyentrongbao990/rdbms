create schema bt01;
set search_path to bt01;
create table customers(
	customer_id serial primary key,
	name varchar(50),
	email varchar(50)
);
create table customer_log(
	log_id serial primary key,
	customer_name varchar(50),
	action_time timestamp
);

create or replace function log_customer_insert()
returns trigger
language plpgsql
as $$
begin
	insert into customer_log(customer_name,action_time) values
	(new.name, now());
	return new;
end;
$$;

create trigger trg_log_customer_after_insert
after insert on customers
for each row
execute function log_customer_insert();

-- them vai khach hang
insert into customers (name, email)
values
  ('nguyen van a', 'a@gmail.com'),
  ('tran thi b', 'b@gmail.com'),
  ('le van c', 'c@gmail.com');

-- kiem tra bang customers
select * from customers order by customer_id;

-- kiem tra bang customer_log (phai co 3 dong tuong ung)
select * from customer_log order by log_id;

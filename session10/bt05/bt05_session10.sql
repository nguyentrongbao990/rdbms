create schema bt05;
set search_path to bt05;
create table customers(
	id bigserial primary key,
	name text not null,
	email text not null unique,
	phone varchar(10) not null,
	address text not null
);
create table customers_log(
	log_id bigserial primary key,
	customer_id bigint,
	operation text not null,
	old_data jsonb,
	new_data jsonb,
	changed_by text not null,
	change_time timestamptz not null default now()
);
-- trigger function
create or replace function log_customer_changes()
returns trigger
language plpgsql
as $$
begin
	if tg_op='INSERT' then
		insert into customers_log(customer_id,operation,old_data, new_data, changed_by) values
			(new.id,tg_op,null,to_jsonb(new),current_user);
			return new;
	elsif tg_op='UPDATE' then
		insert into customers_log(customer_id,operation,old_data, new_data, changed_by) values
			(new.id,tg_op,to_jsonb(old),to_jsonb(new),current_user);
		return new;
	elsif tg_op = 'DELETE' then
		insert into customers_log(customer_id,operation,old_data, new_data, changed_by) values
			(old.id,tg_op,to_jsonb(old), null,current_user);
		return old;
	end if;
	return null;
end;
$$;
--trigger
create trigger trg_customer_log
after insert or update or delete on customers
for each row
execute function log_customer_changes();

--test
insert into customers(name, email, phone, address)
values ('an', 'an@example.com', '0900000000', 'hcm');

update customers
set phone = '0911111111', address = 'hn'
where email = 'an@example.com';

delete from customers
where email = 'an@example.com';

select log_id, customer_id, operation, old_data, new_data, changed_by, change_time
from customers_log
order by log_id;
--1	1	"INSERT"		"{""id"": 1, ""name"": ""an"", ""email"": ""an@example.com"", ""phone"": ""0900000000"", ""address"": ""hcm""}"	"postgres"	"2026-01-27 23:33:18.517519+07"
--2	1	"UPDATE"	"{""id"": 1, ""name"": ""an"", ""email"": ""an@example.com"", ""phone"": ""0900000000"", ""address"": ""hcm""}"	"{""id"": 1, ""name"": ""an"", ""email"": ""an@example.com"", ""phone"": ""0911111111"", ""address"": ""hn""}"	"postgres"	"2026-01-27 23:33:23.707072+07"
--3	1	"DELETE"	"{""id"": 1, ""name"": ""an"", ""email"": ""an@example.com"", ""phone"": ""0911111111"", ""address"": ""hn""}"		"postgres"	"2026-01-27 23:33:27.196967+07"
create schema bt01;
set search_path to bt01;
create table products(
	id bigserial primary key,
	name varchar(100),
	price numeric(12,2),
	last_modified timestamptz default now()
);

--du lieu mau
insert into products(name, price) values
('pencil', 10.00),
('notebook', 25.00),
('mouse', 150.00);

create or replace function update_last_modified()
returns trigger
language plpgsql
as $$
begin
	new.last_modified := now();
	return new;
end;
$$;

create trigger trg_update_last_modified
before update on products
for each row
execute function update_last_modified();

--test thu
update products
set price = price +1
where id =1;
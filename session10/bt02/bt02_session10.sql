create schema bt02;
set search_path to bt02;
create table customers(
	id bigserial primary key,
	name varchar(100) not null,
	credit_limit numeric(10,2) not null
);

create table orders (
	id bigserial primary key,
	customer_id bigint references customers(id),
	order_amount numeric(10,2) not null check(order_amount >0)
);
--du lieu mau
insert into customers(name, credit_limit) values
('an', 1000.00),
('binh', 500.00);

create or replace function check_credit_limit()
returns trigger
language plpgsql
as $$
declare
	v_limit numeric;
	v_current_total numeric;
begin
	select c.credit_limit into v_limit
	from customers c
	where c.id = new.customer_id;

	if not found
		then raise exception 'customer not found';
	end if;

	select coalesce(sum(o.order_amount),0) into v_current_total
	from orders o
	where o.customer_id= new.customer_id;

	if v_current_total+ new.order_amount > v_limit then
		raise exception 'credit limit exceeded: current=%, new=%, limit=%',
      	v_current_total, new.order_amount, v_limit;
	end if;
	return new;
end;
$$;

create trigger trg_check_credit
before insert on orders
for each row
execute function check_credit_limit();

-- xem hạn mức
select * from customers order by id;
-- hợp lệ: an (limit 1000)
insert into orders(customer_id, order_amount) values (1, 400.00);
insert into orders(customer_id, order_amount) values (1, 500.00); -- tổng 900

-- vượt hạn mức: thêm 200 => 1100 > 1000 (bị chặn)
insert into orders(customer_id, order_amount) values (1, 200.00);

-- hợp lệ: binh (limit 500)
insert into orders(customer_id, order_amount) values (2, 300.00);

-- vượt hạn mức: thêm 250 => 550 > 500 (bị chặn)
insert into orders(customer_id, order_amount) values (2, 250.00);

-- kiểm tra dữ liệu còn lại (những câu bị chặn sẽ không insert)
select * from orders order by id;

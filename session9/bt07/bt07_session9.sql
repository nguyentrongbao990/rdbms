--tạo bảng + dữ liệu mẫu
create schema if not exists bt07;
set search_path to bt07;

create table customers (
  customer_id int primary key,
  name text not null,
  email text not null
);

create table orders (
  order_id bigserial primary key,
  customer_id int not null references customers(customer_id),
  amount numeric(12,2) not null,
  order_date date not null default current_date
);

insert into customers(customer_id, name, email) values
(1, 'an', 'an@example.com'),
(2, 'binh', 'binh@example.com');
-- procedure add_order
create or replace procedure add_order(
  p_customer_id int,
  p_amount numeric
)
language plpgsql
as $$
begin
  if p_amount is null or p_amount <= 0 then
    raise exception 'amount must be > 0';
  end if;

  if not exists (
    select 1
    from customers c
    where c.customer_id = p_customer_id
  ) then
    raise exception 'customer_id % not found', p_customer_id;
  end if;

  insert into orders(customer_id, amount)
  values (p_customer_id, p_amount);
end;
$$;
--gọi thử để test
-- case đúng
call add_order(1, 250.00);

-- case sai: customer không tồn tại
call add_order(999, 100.00);

-- xem kết quả
select * from orders order by order_id;
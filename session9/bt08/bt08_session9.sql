-- tạo bảng + dữ liệu mẫu
create schema if not exists bt08;
set search_path to bt08;

drop table if exists orders;
drop table if exists customers;

create table customers (
  customer_id int primary key,
  name text not null,
  total_spent numeric(12,2) not null default 0
);

create table orders (
  order_id bigserial primary key,
  customer_id int not null references customers(customer_id),
  total_amount numeric(12,2) not null
);

insert into customers(customer_id, name, total_spent) values
(1, 'an', 0),
(2, 'binh', 100.00);
--procedure add_order_and_update_customer
create or replace procedure add_order_and_update_customer(
  p_customer_id int,
  p_amount numeric
)
language plpgsql
as $$
declare
  v_order_id bigint;
begin
  if p_amount is null or p_amount <= 0 then
    raise exception 'amount must be > 0';
  end if;

  if not exists (
    select 1 from customers c where c.customer_id = p_customer_id
  ) then
    raise exception 'customer not found';
  end if;

  begin
    insert into orders(customer_id, total_amount)
    values (p_customer_id, p_amount)
    returning order_id into v_order_id;

    update customers
    set total_spent = total_spent + p_amount
    where customer_id = p_customer_id;

    if not found then
      raise exception 'failed to update customer total_spent';
    end if;

  exception
    when others then
      raise exception 'add order failed: %', sqlerrm;
  end;
end;
$$;
-- gọi thử + test
-- case đúng
call add_order_and_update_customer(1, 250.00);

-- case sai (customer không tồn tại)
call add_order_and_update_customer(999, 100.00);
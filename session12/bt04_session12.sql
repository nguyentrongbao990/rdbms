create table orders (
  order_id serial primary key,
  product_id int references products(product_id),
  quantity int,
  total_amount numeric(10,2)
);

-- function: tu dong tinh total_amount = quantity * price truoc khi insert
create or replace function fn_calc_order_total_before_insert()
returns trigger
language plpgsql
as $$
declare
  v_price numeric(10,2);
begin
  -- kiem tra quantity hop le
  if new.quantity is null or new.quantity <= 0 then
    raise exception 'quantity phai > 0';
  end if;

  -- lay price tu products
  select price into v_price
  from products
  where product_id = new.product_id;

  -- neu khong tim thay san pham
  if not found then
    raise exception 'product_id = % khong ton tai', new.product_id;
  end if;

  -- tinh tong tien
  new.total_amount := new.quantity * v_price;

  return new;
end;
$$;

-- tao trigger
drop trigger if exists trg_orders_before_insert_calc_total on orders;

create trigger trg_orders_before_insert_calc_total
before insert on orders
for each row
execute function fn_calc_order_total_before_insert();

-- them don hang (khong can nhap total_amount, trigger se tu tinh)
insert into orders (product_id, quantity)
values
  (1, 2),  -- total = 2 * price(product 1)
  (2, 3);  -- total = 3 * price(product 2)

-- kiem tra
select * from orders order by order_id;

-- quantity sai
insert into orders (product_id, quantity) values (1, 0);

-- product_id khong ton tai
insert into orders (product_id, quantity) values (999, 1);

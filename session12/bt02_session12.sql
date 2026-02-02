create schema bt02;
set search_path to bt02;

create table products(
	product_id serial primary key,
	name varchar(100),
	stock int
);

create table sales(
	sale_id serial primary key,
	product_id int references products(product_id),
	quantity int
);
-- du lieu mau
-- them 2 san pham de test ton kho
insert into products (name, stock)
values
  ('product 1', 5),
  ('product 2', 2);

select * from products order by product_id;

--trigger function
create or replace function fn_check_stock_before_sale()
returns trigger
language plpgsql
as $$
declare
  v_stock int;
begin
  -- kiem tra so luong phai duong
  if new.quantity is null or new.quantity <= 0 then
    raise exception 'quantity phai > 0';
  end if;

  -- lay ton kho cua san pham
  select stock into v_stock
  from products
  where product_id = new.product_id;

  -- neu khong tim thay san pham
  if not found then
    raise exception 'product_id = % khong ton tai', new.product_id;
  end if;

  -- neu vuot qua ton kho => chan insert
  if new.quantity > v_stock then
    raise exception 'khong du ton kho: product_id = %, ton kho = %, yeu cau = %',
      new.product_id, v_stock, new.quantity;
  end if;

  -- du ton kho => cho phep insert vao sales
  return new;
end;
$$;

-- trigger
create trigger trg_sales_before_insert_check_stock
before insert on sales
for each row
execute function fn_check_stock_before_sale();

--test
--product 1 ton kho 5, ban 3 => ok
insert into sales (product_id, quantity)
values (1, 3);

select * from sales order by sale_id;
-- product 2 ton kho 2, ban 5 => loi (trigger raise exception)
insert into sales (product_id, quantity)
values (2, 5);
-- quantity <=0
insert into sales (product_id, quantity)
values (1, 0);


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

-- function: sau khi insert vao sales, tu dong tru stock trong products
create or replace function fn_reduce_stock_after_sale()
returns trigger
language plpgsql
as $$
begin
  -- tru ton kho bang dung so luong vua ban (new.quantity)
  update products
  set stock = stock - new.quantity
  where product_id = new.product_id;

  -- tra ve new (after trigger khong bat buoc, nhung nen co)
  return new;
end;
$$;

-- trigger: sau khi them 1 dong vao sales thi goi function tru kho

create trigger trg_sales_after_insert_reduce_stock
after insert on sales
for each row
execute function fn_reduce_stock_after_sale();

--test
--thêm đơn hàng (ví dụ bán product_id = 1 số lượng 2)
insert into sales (product_id, quantity)
values (1, 2);
-- kiem tra lai
select * from sales order by sale_id;
--1	1	3
--4	1	2
select * from products order by product_id;
--1	"product 1"	3
--2	"product 2"	2

create schema bt03;
set search_path to bt03;
create table products(
	product_id serial primary key,
	product_name varchar(100),
	stock int,
	price numeric(10,2)
);
create table orders(
	order_id serial primary key,
	customer_name varchar(100),
	total_amount numeric(10,2),
	created_at timestamp default now()
);
create table order_items(
	order_item_id serial primary key,
	order_id int references orders(order_id),
	product_id int references products(product_id),
	quantity int,
	subtotal numeric(10,2)
);
INSERT INTO products (product_name, stock, price)
VALUES
('Product 1', 10, 50.00),
('Product 2', 5,  30.00);

-- dat hang cho khach: nguyen van a
-- gio hang:
--   product_id = 1, quantity = 2
--   product_id = 2, quantity = 1
-- yeu cau:
--   - neu 1 trong 2 san pham khong du ton kho => rollback toan bo
--   - neu du hang => tru kho, tao orders, tao order_items, cap nhat total_amount

-- dat hang cho khach: nguyen van a
-- gio hang:
--   product_id = 1, quantity = 2
--   product_id = 2, quantity = 1
-- yeu cau:
--   - neu 1 trong 2 san pham khong du ton kho => rollback toan bo
--   - neu du hang => tru kho, tao orders, tao order_items, cap nhat total_amount

do $$
declare
  -- luu id don hang vua tao
  v_order_id int;

  -- luu gia cua tung san pham (lay tu products)
  v_price_1  numeric(10,2);
  v_price_2  numeric(10,2);

  -- tong tien cua don hang
  v_total    numeric(10,2);
begin
  -- (1) kiem tra + tru ton kho san pham 1 (qty = 2)
  --     dieu kien stock >= 2 de dam bao khong bi am kho
  --     returning price de lay gia san pham 1 (phuc vu tinh tien)
  update products
  set stock = stock - 2
  where product_id = 1
    and stock >= 2
  returning price into v_price_1;

  -- neu update khong cap nhat dong nao => san pham 1 khong ton tai hoac khong du hang
  if not found then
    raise exception 'loi: product_id = 1 khong du hang (hoac khong ton tai) => rollback';
  end if;

  -- (2) kiem tra + tru ton kho san pham 2 (qty = 1)
  update products
  set stock = stock - 1
  where product_id = 2
    and stock >= 1
  returning price into v_price_2;

  -- neu san pham 2 khong du hang => rollback toan bo (bao gom ca tru kho san pham 1)
  if not found then
    raise exception 'loi: product_id = 2 khong du hang (hoac khong ton tai) => rollback';
  end if;

  -- (3) tao don hang trong bang orders (tam de total_amount = 0)
  insert into orders (customer_name, total_amount)
  values ('nguyen van a', 0)
  returning order_id into v_order_id;

  -- (4) them chi tiet san pham vao bang order_items
  --     subtotal = quantity * price
  insert into order_items (order_id, product_id, quantity, subtotal)
  values
    (v_order_id, 1, 2, 2 * v_price_1),
    (v_order_id, 2, 1, 1 * v_price_2);

  -- (5) tinh tong tien don hang = tong cac subtotal
  select sum(subtotal) into v_total
  from order_items
  where order_id = v_order_id;

  -- (6) cap nhat total_amount vao orders
  update orders
  set total_amount = v_total
  where order_id = v_order_id;

  -- (7) thong bao thanh cong
  raise notice 'thanh cong: order_id = %, total_amount = %', v_order_id, v_total;
end $$;

-- kiem tra ton kho: du kien product 1: 10 -> 8, product 2: 5 -> 4
select * from products order by product_id;

-- kiem tra don hang vua tao (dong moi nhat o tren)
select * from orders order by order_id desc limit 5;

-- kiem tra chi tiet don hang
select * from order_items order by order_item_id desc limit 10;

-- mo phong het hang san pham 2
update products
set stock = 0
where product_id = 2;

select * from products order by product_id;

do $$
declare
  v_order_id int;
  v_price_1  numeric(10,2);
  v_price_2  numeric(10,2);
  v_total    numeric(10,2);
begin
  -- tru kho san pham 1 (qty = 2)
  update products
  set stock = stock - 2
  where product_id = 1
    and stock >= 2
  returning price into v_price_1;

  if not found then
    raise exception 'loi: product_id = 1 khong du hang (hoac khong ton tai) => rollback';
  end if;

  -- tru kho san pham 2 (qty = 1) => luc nay stock = 0 nen se fail
  update products
  set stock = stock - 1
  where product_id = 2
    and stock >= 1
  returning price into v_price_2;

  if not found then
    raise exception 'loi: product_id = 2 khong du hang (hoac khong ton tai) => rollback';
  end if;

  -- neu den duoc day thi moi tao order (nhung truong hop loi thi se khong bao gio toi day)
  insert into orders (customer_name, total_amount)
  values ('nguyen van a', 0)
  returning order_id into v_order_id;

  insert into order_items (order_id, product_id, quantity, subtotal)
  values
    (v_order_id, 1, 2, 2 * v_price_1),
    (v_order_id, 2, 1, 1 * v_price_2);

  select sum(subtotal) into v_total
  from order_items
  where order_id = v_order_id;

  update orders
  set total_amount = v_total
  where order_id = v_order_id;

  raise notice 'thanh cong: order_id = %, total_amount = %', v_order_id, v_total;
end $$;

-- - khong co order moi duoc tao
-- - stock product 1 khong bi tru them (vi rollback toan bo)
-- - product 2 van stock = 0

select * from products order by product_id;

select * from orders order by order_id desc limit 5;

select * from order_items order by order_item_id desc limit 10;

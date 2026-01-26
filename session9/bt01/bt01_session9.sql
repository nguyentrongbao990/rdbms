create schema bt01;
set search_path to bt01;
create table orders (
	order_id bigint generated always as identity primary key,
	customer_id int not null,
	order_date date not null,
	total_amount numeric(12,2) not null
);
--tao du lieu mau
INSERT INTO orders (customer_id, order_date, total_amount)
SELECT
  CASE
    WHEN random() < 0.10 THEN 1                          -- ~10% đơn thuộc customer_id=1
    ELSE (2 + floor(random() * 99999))::int              -- còn lại rải 2..100000
  END AS customer_id,
  (DATE '2023-01-01' + (floor(random() * 730))::int) AS order_date,  -- 2 năm
  round((random() * 5000 + 10)::numeric, 2) AS total_amount
FROM generate_series(1, 1000000);
ANALYZE orders;
--trước khi tạo index
explain analyze
select *
from orders
where customer_id = 50000;
--Gather  (cost=1000.00..12579.63 rows=13 width=22) (actual time=4.904..50.564 rows=8.00 loops=1)
--Execution Time: 50.588 ms

--tạo index b-tree
create index idx_orders_customer_id on orders(customer_id);
analyze orders;
--đo lại sau khi có index
--Bitmap Heap Scan on orders  (cost=4.53..54.93 rows=13 width=22) (actual time=0.073..0.082 rows=8.00 loops=1)
--Execution Time: 0.098 ms
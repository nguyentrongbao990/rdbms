create schema bt_2_ban_hang;
set search_path to bt_2_ban_hang;
create table customer(
	customer_id serial primary key,
	full_name varchar(100),
	email varchar(100),
	phone varchar(10)
);
create table orders(
	order_id serial primary key,
	customer_id int references customer(customer_id),
	total_amount decimal(10,2),
	order_date date
);
INSERT INTO customer(full_name, email, phone) VALUES
('Nguyen Van A', 'a@gmail.com', '0900000001'),
('Tran Thi B', 'b@gmail.com', '0900000002');
INSERT INTO orders(customer_id, total_amount, order_date) VALUES
(1, 1500000.00, '2024-08-05'),
(1,  200000.00, '2024-08-20'),
(2,  900000.00, '2024-09-02');
--Tạo một View tên v_order_summary hiển thị:
--full_name, total_amount, order_date
--(ẩn thông tin email và phone)
create view if not exists v_order_summary as
select c.full_name, o.total_amount, o.order_date
from customer c
join orders o on c.customer_id= o.customer_id;
--Viết truy vấn để xem tất cả dữ liệu từ View
select * from v_order_summary;
--Tạo một View thứ hai v_monthly_sales thống kê tổng doanh thu mỗi tháng
create view v_monthly_sales as
select
	sum(total_amount) as total_amount,
	to_char(order_date,'YYYY-MM') as month
from orders
group by month
order by month;
--Thử DROP View và ghi chú sự khác biệt giữa DROP VIEW và DROP MATERIALIZED VIEW trong PostgreSQL
drop view if exists v_order_summary;
drop view if exists v_monthly_sales;
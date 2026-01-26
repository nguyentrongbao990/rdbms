create schema bt04;
set search_path to bt04;
create table sales(
	sale_id bigint generated always as identity primary key,
	customer_id int not null,
	product_id int not null,
	sale_date date not null,
	amount numeric(12,2) not null
);

--dữ liệu mẫu

INSERT INTO sales(customer_id, product_id, sale_date, amount) VALUES
(1, 101, '2024-01-05', 200.00),
(1, 102, '2024-01-10', 900.00),
(2, 103, '2024-01-07', 1500.00),
(3, 101, '2024-01-09', 300.00),
(3, 104, '2024-01-15', 800.00),
(4, 105, '2024-01-20', 50.00);

-- tạo view
create or replace view CustomerSales as
select sum(amount) as total_amount,customer_id
from sales
group by customer_id;

--truy vấn
select * from customersales
where total_amount > 1000;
--Thử cập nhật một bản ghi qua View và quan sát kết quả
UPDATE CustomerSales
SET total_amount = 9999
WHERE customer_id = 1;
--ERROR:  cannot update view "customersales"
--Views containing GROUP BY are not automatically updatable. 

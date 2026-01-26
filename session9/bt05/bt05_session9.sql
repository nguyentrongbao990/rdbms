create schema bt05;
set search_path to bt05;
create table sales(
	sale_id int generated always as identity primary key,
	customer_id int not null,
	amount numeric(10,2) not null,
	sale_date date not null
);
-- dữ liệu mẫu
insert into sales(customer_id, amount, sale_date) values
(1, 200.00, '2024-01-05'),
(1, 900.00, '2024-01-10'),
(2, 1500.00,'2024-01-07'),
(3, 300.00, '2024-02-01'),
(3, 800.00, '2024-02-15');
--Tạo Procedure calculate_total_sales(start_date DATE, end_date DATE, OUT total NUMERIC) để tính tổng amount trong khoảng start_date đến end_date
create or replace procedure calculate_total_sales(
  start_date date,
  end_date date,
  out total numeric
)
language plpgsql
as $$
begin
  select coalesce(sum(s.amount), 0)
  into total
  from sales s
  where s.sale_date between start_date and end_date;
end;
$$;
-- gọi procedure
call calculate_total_sales('2024-01-01', '2024-01-31', null);  -- 2600.00
call calculate_total_sales('2024-02-01', '2024-02-28', null);  -- 1100.00
call calculate_total_sales('2023-01-01', '2023-12-31', null);  -- 0

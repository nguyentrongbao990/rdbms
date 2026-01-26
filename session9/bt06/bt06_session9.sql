create schema bt06;
set search_path to bt06;
create table products(
	product_id int generated always as identity primary key,
	name varchar(200) not null,
	price numeric(10,2) not null,
	category_id int not null
);
--dữ liệu mẫu
insert into products(name, price, category_id) values
('pencil',   10.00, 1),
('notebook', 25.00, 1),
('mouse',   150.00, 2),
('keyboard',300.00, 2),
('chair',   500.00, 3);
--Tạo Procedure update_product_price(p_category_id INT, p_increase_percent NUMERIC) để tăng giá tất cả sản phẩm trong một category_id theo phần trăm
--Sử dụng biến để tính giá mới cho từng sản phẩm trong vòng lặp
create or replace procedure update_product_price (
	p_category_id int,
	p_increase_percent numeric
)
language plpgsql
as $$
declare
	r record;
	v_new_price numeric(10,2);
begin
	if p_increase_percent <= 0 then
    	raise exception 'increase percent must be > 0';
  	end if;

	for r in
		select product_id, price
		from products
		where category_id = p_category_id
	loop
		v_new_price := r.price * (1+p_increase_percent/100.0);
		update products
		set price = v_new_price
		where product_id = r.product_id;
	end loop;
end;
$$;
--Thử gọi Procedure với các tham số mẫu và kiểm tra kết quả trong bảng Products
select * from products order by product_id;
call update_product_price(1, 10);  -- category 1 tăng 10%
call update_product_price(2, 5);   -- category 2 tăng 5%
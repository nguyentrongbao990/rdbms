create table products(
	product_id serial primary key,
	product_name varchar(100) not null,
	category varchar(100) not null
);

create table orders (
	order_id int primary key,
	product_id int references products(product_id),
	quantity int,
	total_price numeric(10,2)
);
insert into products (product_name, category) values
('Laptop Dell','Electronics'),
('IPhone 15','Electronics'),
('Bàn học gỗ','Furniture'),
('Ghế xoay','Furniture');
insert into orders(order_id, product_id, quantity, total_price) values
(101,1,2,2200),
(102,2,3,3300),
(103,3,5,2500),
(104,4,4,1600),
(105,1,1,1100);
/*
Viết truy vấn hiển thị tổng doanh thu (SUM(total_price)) và số lượng sản phẩm bán được (SUM(quantity)) cho từng nhóm danh mục (category)
Đặt bí danh cột như sau:
total_sales cho tổng doanh thu
total_quantity cho tổng số lượng
*/
select p.category ,sum(o.total_price) as total_sales, sum(o.quantity) as total_quantity
from orders o join products p on o.product_id = p.product_id
group by p.category
--Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
having sum(o.total_price) > 2000
--Sắp xếp kết quả theo tổng doanh thu giảm dần
order by total_sales desc;


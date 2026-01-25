create table if not exists customers(
	customer_id int generated always as identity primary key,
	full_name varchar(100),
	email varchar(100) unique,
	city varchar(50)
);
create table if not exists products(
	product_id int generated always as identity primary key,
	product_name varchar(100),
	category text[],
	price numeric (10,2)
);
create table if not exists orders(
	order_id int generated always as identity primary key,
	customer_id int references customers(customer_id),
	product_id int references products(product_id),
	order_date date,
	quantity int
);
--1) thêm dữ liệu mẫu
INSERT INTO customers (full_name, email, city) VALUES
('Nguyễn Văn An',   'an.nguyen@example.com',   'Hà Nội'),
('Trần Thị Bình',   'binh.tran@example.com',   'TP.HCM'),
('Lê Minh Châu',    'chau.le@example.com',     'Đà Nẵng'),
('Phạm Quốc Dũng',  'dung.pham@example.com',   'Cần Thơ'),
('Võ Hải Yến',      'yen.vo@example.com',      'Hải Phòng');
INSERT INTO products (product_name, category, price) VALUES
('Tai nghe Bluetooth X1',     ARRAY['electronics','audio'],      499000.00),
('Bàn phím cơ K2',            ARRAY['electronics','keyboard'],   1299000.00),
('Bình giữ nhiệt 750ml',      ARRAY['home','kitchen'],           259000.00),
('Sách SQL căn bản',          ARRAY['books','education'],        189000.00),
('Chuột không dây M330',      ARRAY['electronics','mouse'],      359000.00);
INSERT INTO orders (customer_id, product_id, order_date, quantity) VALUES
(1, 1, '2024-08-01', 1),
(1, 4, '2024-08-02', 2),
(2, 2, '2024-08-03', 1),
(2, 5, '2024-08-05', 2),
(3, 3, '2024-08-06', 3),
(3, 1, '2024-08-08', 1),
(4, 4, '2024-08-10', 1),
(4, 2, '2024-08-12', 1),
(5, 5, '2024-08-15', 1),
(5, 3, '2024-08-18', 2);
--2) Tối ưu truy vấn tìm kiếm khách hàng và sản phẩm
--Tạo chỉ mục B-tree trên cột email để tối ưu tìm khách hàng theo email
create index idx_b_tree_email on customers(email);
--Tạo chỉ mục Hash trên cột city để lọc theo thành phố
create index idx_hash_city on customers using hash(city);
--Tạo chỉ mục GIN trên cột category của products để hỗ trợ tìm theo danh mục (mảng)
create index idx_gin_category on products using gin(category);
--Tạo chỉ mục GiST trên cột price để hỗ trợ tìm sản phẩm trong khoảng giá
create index idx_gist_price on products using gist(price);
--3)Thực hiện một số truy vấn trước và sau khi có Index:
--Tìm khách hàng có email cụ thể
explain analyze
select customer_id,full_name,city
from customers
where email='binh.tran@example.com';
--truoc khi tao index
--Index Scan using customers_email_key on customers  (cost=0.14..8.16 rows=1 width=340) (actual time=0.035..0.036 rows=1.00 loops=1)
--Planning Time: 0.112 ms
--Execution Time: 0.070 ms
--sau khi tao index

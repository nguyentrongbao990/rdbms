create table products(
	id serial primary key,
	name varchar(50) not null,
	category varchar(100) not null,
	price numeric(10,2) not null,
	stock int,
	manufacturer varchar(50) not null
);
insert into products(name,category,price, stock, manufacturer) values
('Laptop Dell XPS 13','Phụ kiện','25000000','12','Dell'),
('Chuột Logitech M90','Laptop','150000','50','Logitech'),
('Bàn phím cơ Razer','Phụ kiện','2200000','0','Razer'),
('Macbook Air M2','Laptop','32000000','7','Apple'),
('iPhone 14 Pro Max','Điện thoại','35000000','15','Apple'),
('Laptop Dell XPS 13','Laptop','25000000','12','Dell'),
('Tai nghe AirPods 3','Phụ kiện','4500000',Null,'Apple');
select * from products;
--Chèn dữ liệu mới:
--Thêm sản phẩm “Chuột không dây Logitech M170”, loại Phụ kiện, giá 300000, tồn kho 20, hãng Logitech
insert into products (name,category,price, stock, manufacturer) values
('Chuột không dây Logitech M170','Phụ kiện','300000','20','Logitech');
--Cập nhật dữ liệu:
--Tăng giá tất cả sản phẩm của Apple thêm 10%
update products
set price = price * 1.1
where manufacturer = 'Apple';
--Xóa dữ liệu:
--Xóa sản phẩm có stock = 0
delete from products
where stock =0;
--Lọc theo điều kiện:
--Hiển thị sản phẩm có price BETWEEN 1000000 AND 30000000
select name, price from products
where price between 1000000 AND 30000000;
--Lọc giá trị NULL:
--Hiển thị sản phẩm có stock IS NULL
select * from products
where stock is null;
--Loại bỏ trùng:
--Liệt kê danh sách hãng sản xuất duy nhất
select distinct manufacturer from products;
--Sắp xếp dữ liệu
--Hiển thị toàn bộ sản phẩm, sắp xếp giảm dần theo giá, sau đó tăng dần theo tên
select * from products
order by price desc, name asc;
--Tìm kiếm (LIKE và ILIKE):
--Tìm sản phẩm có tên chứa từ “laptop” (không phân biệt hoa thường)
select * from products
where name ilike '%laptop%';
--Giới hạn kết quả:
--Chỉ hiển thị 2 sản phẩm đầu tiên sau khi sắp xếp
select * from products
order by price desc
limit 2;
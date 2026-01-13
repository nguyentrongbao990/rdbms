create table books(
	id int generated always as identity primary key,
	title varchar(200) not null,
	author varchar (50) not null,
	category varchar (20) not null,
	publish_year int not null,
	price numeric(10,2) not null,
	stock int
);
insert into books (title, author, category,publish_year,price, stock) values
('Lập trình C cơ bản','Nguyễn Văn Nam','CNTT',2018,95000,20),
('Học SQL qua ví dụ','Trần Thị Hạnh','CSDL',2020,125000,12),
('Lập trình C cơ bản','Nguyễn Văn Nam','CNTT',2018,95000,20),
('Phân tích dữ liệu với Python','Lê Quốc Bảo','CNTT',2022,180000,null),
('Quản trị cơ sở dữ liệu','Nguyễn Thị Minh','CSDL',2021,150000,5),
('Học máy cho người mới bắt đầu','Nguyễn Văn Nam','AI',2023,220000,8),
('Khoa học dữ liệu cơ bản','Nguyễn Văn Nam','AI',2023,220000,null);
--test
select * from books;
--Chuẩn hóa dữ liệu:
--Xóa các bản ghi trùng lặp hoàn toàn về title, author và publish_year
delete from books s
using books s2
where s.title = s2.title
	and s.author = s2.author
	and s.publish_year = s2.publish_year
	and s.ctid > s2.ctid;
--Cập nhật giá:
--Tăng giá 10% cho những sách xuất bản từ năm 2021 trở đi và có price < 200000
update books
set price = price * 1.1
where publish_year>= 2021 and price <200000;
--Xử lý lỗi nhập:
--Với những sách có stock IS NULL, cập nhật stock = 0
update books
set stock = 0
where stock is null;
-- Truy vấn nâng cao:
--Liệt kê danh sách sách thuộc chủ đề CNTT hoặc AI có giá trong khoảng 100000 - 250000
--Sắp xếp giảm dần theo price, rồi tăng dần theo title
select * from books
where category in ('CNTT','AI')
	and price between 100000 and 250000
order by price desc, title asc;
--Tìm kiếm tự do:
--Tìm các sách có tiêu đề chứa từ “học” (không phân biệt hoa thường)
--Gợi ý: dùng ILIKE '%học%'
select * from books
where title ilike '%học%';
--Thống kê chuyên mục:
--Liệt kê các thể loại duy nhất (DISTINCT) có ít nhất một cuốn sách xuất bản sau năm 2020
select distinct category
from books
where publish_year >2020;
--Phân trang kết quả:
--Chỉ hiển thị 2 kết quả đầu tiên, bỏ qua 1 kết quả đầu tiên (dùng LIMIT + OFFSET)
select title from books
order by price desc
limit 2 offset 1;

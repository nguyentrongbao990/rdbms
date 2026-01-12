create table students(
	id serial primary key,
	name varchar(50),
	age int,
	major varchar(50),
	gpa decimal(3,2)
);
insert into students (name,age, major,gpa) values
('An',20,'CNTT',3.5),
('Bình',21,'Toán',3.2),
('Cường',22,'CNTT',3.8),
('Dương',20,'Vật lý',3.0),
('Em',21,'CNTT',2.9);
--Thêm sinh viên mới: "Hùng", 23 tuổi, chuyên ngành "Hóa học", GPA 3.4
insert into students (name, age, major, gpa) values
('Hùng',23,'Hóa học',3.4);
--test
select * from students;
--Cập nhật GPA của sinh viên "Bình" thành 3.6
update students set gpa = 3.6
where name ='Bình';
--Xóa sinh viên có GPA thấp hơn 3.0
delete from students
where gpa< 3.0;
--Liệt kê tất cả sinh viên, chỉ hiển thị tên và chuyên ngành, sắp xếp theo GPA giảm dần
select name, major from students
order by gpa desc;
--Liệt kê tên sinh viên duy nhất có chuyên ngành "CNTT"
select distinct name
from students
where major = 'CNTT';
--Liệt kê sinh viên có GPA từ 3.0 đến 3.6
select * from students
where gpa between 3.0 and 3.6;
--Liệt kê sinh viên có tên bắt đầu bằng chữ 'C' (sử dụng LIKE/ILIKE)
select * from students
where name ilike 'C%';
--Hiển thị 3 sinh viên đầu tiên theo thứ tự tên tăng dần, hoặc lấy từ sinh viên thứ 2 đến thứ 4 bằng LIMIT và OFFSET
select * from students
order by name limit 3;

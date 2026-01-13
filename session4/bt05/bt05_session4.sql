create table employees(
	id serial primary key,
	full_name varchar(100) not null,
	department varchar(20) not null,
	position varchar(50) not null,
	salary numeric(10,0) not null,
	bonus numeric(10,0),
	join_year int
);
insert into employees(full_name,department,position,salary,bonus,join_year) values
('Nguyễn Văn Huy', 'IT',      'Developer', 18000000, 1000000, 2021),
('Trần Thị Mai',   'HR',      'Recruiter', 12000000, NULL,    2020),
('Lê Quốc Trung',  'IT',      'Tester',    15000000, 800000,  2023),
('Nguyễn Văn Huy', 'IT',      'Developer', 18000000, 1000000, 2021),
('Phạm Ngọc Hân',  'Finance', 'Accountant',14000000, NULL,    2019),
('Bùi Thị Lan',    'HR',      'HR Manager',20000000, 3000000, 2018),
('Đặng Hữu Tài',   'IT',      'Developer', 17000000, NULL,    2022);

select * from employees;
--Chuẩn hóa dữ liệu:
--Xóa các bản ghi trùng nhau hoàn toàn về tên, phòng ban và vị trí
delete from employees e
using employees e2
where e.full_name= e2.full_name
and e.department=e2.department
and e.position = e2.position
and e.ctid >e2.ctid;
--Cập nhật lương thưởng:
--Tăng 10% lương cho những nhân viên làm trong phòng IT có mức lương dưới 18,000,000//
update employees
set salary = salary *1.1
where department = 'IT' and salary < 18000000;
--Với nhân viên có bonus IS NULL, đặt giá trị bonus = 500000
update employees
set bonus = 500000
where bonus is null;
--Truy vấn:
--Hiển thị danh sách nhân viên thuộc phòng IT hoặc HR, gia nhập sau năm 2020, và có tổng thu nhập (salary + bonus) lớn hơn 15,000,000
--Chỉ lấy 3 nhân viên đầu tiên sau khi sắp xếp giảm dần theo tổng thu nhập
select id, full_name, department,position, salary, bonus, join_year, (salary + bonus) as total_income
from employees
where (department = 'IT' or department ='HR')
	and join_year >2020
	and (salary + bonus) > 15000000
order by total_income desc
limit 3;
--Truy vấn theo mẫu tên:
--Tìm tất cả nhân viên có tên bắt đầu bằng “Nguyễn” hoặc kết thúc bằng “Hân”
select * from employees
where full_name ilike 'Nguyễn%' or full_name ilike '%Hân';
--Truy vấn đặc biệt:
--Liệt kê các phòng ban duy nhất có ít nhất một nhân viên có bonus IS NOT NULL
select distinct department
from employees
where bonus is not null;
--Khoảng thời gian làm việc:
--Hiển thị nhân viên gia nhập trong khoảng từ 2019 đến 2022 (BETWEEN)
select * from employees
where join_year between 2019 and 2022
order by join_year;
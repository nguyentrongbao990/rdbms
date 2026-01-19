-- 02_dml.sql
-- Run on DB: EmployeePracticeDB

-- 1) Thêm 6 nhân viên mới
INSERT INTO employee (full_name, department, salary, hire_date) VALUES
('Nguyễn An',        'IT',      5500000, '2023-01-10'),
('Trần Văn Bình',    'HR',      7000000, '2022-12-15'),
('Lê Thị An',        'IT',     12000000, '2023-06-20'),
('Phạm Minh Đức',    'Finance', 5800000, '2023-11-05'),
('Đặng Tuấn Anh',    'Sales',   9000000, '2024-03-12'),
('Hoàng Thanh An',   'IT',     15000000, '2023-09-01');

-- 2) Cập nhật mức lương tăng 10% cho nhân viên thuộc phòng IT
UPDATE employee
SET salary = salary * 1.10
WHERE department = 'IT';

-- 3) Xóa nhân viên có mức lương dưới 6,000,000
DELETE FROM employee
WHERE salary < 6000000;

-- 4) Liệt kê nhân viên có tên chứa "An" (không phân biệt hoa thường)
SELECT *
FROM employee
WHERE full_name ILIKE '%an%';

-- 5) Nhân viên có ngày vào làm trong khoảng '2023-01-01' đến '2023-12-31'
SELECT *
FROM employee
WHERE hire_date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY hire_date;

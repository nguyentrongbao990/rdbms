-- 02_dml_queries.sql
-- Run on DB: CourseDB

-- 1) Thêm ít nhất 6 khóa học
INSERT INTO course (title, instructor, price, duration) VALUES
('SQL Cơ bản',              'An',   600000,  20),
('SQL Nâng cao',            'Bình', 1200000, 35),
('PostgreSQL Thực chiến',   'Cường',1800000, 40),
('Java Backend Demo',       'Dũng',  900000, 25),
('Python Data Analysis',    'Hà',   1500000, 45),
('Excel cho người mới',     'Lan',   500000, 10),
('SQL Demo - Mini course',  'Minh',  700000, 15);

-- 2) Cập nhật giá tăng 15% cho các khóa học có thời lượng trên 30 giờ
UPDATE course
SET price = price * 1.15
WHERE duration > 30;

-- 3) Xóa khóa học có tên chứa từ khóa "Demo"
DELETE FROM course
WHERE title ILIKE '%demo%';

-- 4) Hiển thị các khóa học có tên chứa từ "SQL" (không phân biệt hoa thường)
SELECT *
FROM course
WHERE title ILIKE '%sql%'
ORDER BY price DESC;

-- 5) Lấy 3 khóa học có giá nằm giữa 500,000 và 2,000,000, sắp xếp theo giá giảm dần
SELECT *
FROM course
WHERE price BETWEEN 500000 AND 2000000
ORDER BY price DESC
LIMIT 3;

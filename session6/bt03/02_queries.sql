-- 02_queries.sql
-- Run on DB: CustomerPointsDB

-- 1) Thêm 7 khách hàng (có 1 người không có email = NULL)
INSERT INTO customer (name, email, phone, points) VALUES
('Nguyễn Văn A', 'a@gmail.com', '0901000001', 120),
('Trần Thị B',   'b@gmail.com', '0901000002', 300),
('Lê Văn C',     NULL,          '0901000003', 180), -- không có email
('Phạm Thị D',   'd@gmail.com', '0901000004', 450),
('Hoàng Văn E',  'e@gmail.com', '0901000005', 250),
('Đặng Thị F',   'f@gmail.com', '0901000006', 500),
('Nguyễn Văn A', 'a2@gmail.com','0901000007', 220); -- cố tình trùng tên để test DISTINCT

-- 2) Danh sách tên khách hàng duy nhất (DISTINCT)
SELECT DISTINCT name
FROM customer
ORDER BY name;

-- 3) Khách hàng chưa có email (IS NULL)
SELECT *
FROM customer
WHERE email IS NULL;

-- 4) Hiển thị 3 khách hàng có điểm cao nhất, bỏ qua người cao điểm nhất (OFFSET)
-- Giải thích: sắp xếp giảm dần, bỏ 1 dòng đầu tiên (cao nhất), lấy 3 dòng tiếp theo
SELECT *
FROM customer
ORDER BY points DESC
LIMIT 3 OFFSET 1;

-- 5) Sắp xếp danh sách khách hàng theo tên giảm dần
SELECT *
FROM customer
ORDER BY name DESC, id ASC;

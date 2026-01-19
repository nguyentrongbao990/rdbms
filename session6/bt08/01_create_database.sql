-- 01_create_database.sql

-- =========================
-- Part A: run on DB postgres
-- =========================
CREATE DATABASE "CustomerPotentialDB";

-- ==========================================
-- Part B: run on DB CustomerPotentialDB
-- (Dùng cấu trúc Orders giống bài trước)
-- ==========================================

CREATE TABLE IF NOT EXISTS customer (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS orders (
    id           SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customer(id),
    order_date   DATE,
    total_amount NUMERIC(10,2)
);

-- Sample data (có khách chưa từng mua để test câu 3)
TRUNCATE TABLE orders RESTART IDENTITY;
TRUNCATE TABLE customer RESTART IDENTITY CASCADE;

INSERT INTO customer (name) VALUES
('Nguyễn Văn A'),
('Trần Thị B'),
('Lê Văn C'),
('Phạm Thị D'),
('Hoàng Văn E'),  -- sẽ không có đơn hàng
('Đặng Thị F');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-10-02', 5000000),
(1, '2024-11-15', 2500000),
(2, '2024-10-05', 3000000),
(3, '2024-12-20', 9000000),
(4, '2024-10-18',  800000),
(6, '2024-09-30', 4500000);

-- 01_create_database.sql

-- Part A: run on DB postgres
CREATE DATABASE "RevenueDB";

-- Part B: run on DB RevenueDB
CREATE TABLE IF NOT EXISTS orders (
    id           SERIAL PRIMARY KEY,
    customer_id  INT,
    order_date   DATE,
    total_amount NUMERIC(10,2)
);

-- Sample data (đủ để test GROUP BY theo năm và HAVING > 50,000,000)
-- Nếu chạy lại, xóa dữ liệu cũ trước để không bị cộng dồn
TRUNCATE TABLE orders RESTART IDENTITY;

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2022-01-15', 12000000),
(2, '2022-06-10', 18000000),
(3, '2022-11-25', 25000000),  -- Năm 2022: 55,000,000 (đủ điều kiện HAVING)

(1, '2023-02-05',  9000000),
(2, '2023-07-18', 11000000),
(3, '2023-12-20', 14000000),  -- Năm 2023: 34,000,000

(4, '2024-03-12', 30000000),
(5, '2024-08-01', 28000000),
(6, '2024-12-29',  6000000);  -- Năm 2024: 64,000,000 (đủ điều kiện HAVING)

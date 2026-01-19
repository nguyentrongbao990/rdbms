-- 01_create_database.sql

-- =========================
-- Part A: run on DB postgres
-- =========================
CREATE DATABASE "ProductSalesDB";

-- ==========================================
-- Part B: run on DB ProductSalesDB
-- ==========================================

CREATE TABLE IF NOT EXISTS product (
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(100),
    category VARCHAR(50),
    price    NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS orderdetail (
    id         SERIAL PRIMARY KEY,
    order_id   INT,
    product_id INT REFERENCES product(id),
    quantity   INT
);

-- Sample data (có sản phẩm chưa có đơn hàng để test LEFT JOIN)
TRUNCATE TABLE orderdetail RESTART IDENTITY;
TRUNCATE TABLE product RESTART IDENTITY CASCADE;

-- Sau TRUNCATE RESTART IDENTITY, id sản phẩm sẽ chạy từ 1.. theo thứ tự insert
INSERT INTO product (name, category, price) VALUES
('Laptop Dell XPS 13', 'Electronics', 25000000),
('iPhone 15',          'Electronics', 22000000),
('Bàn học gỗ',         'Furniture',    3000000),
('Ghế xoay',           'Furniture',    1600000),
('Chuột Logitech',     'Accessories',   300000),
('Tai nghe AirPods',   'Accessories',  4500000),
('Màn hình 27 inch',   'Electronics',  7000000); -- chưa có đơn hàng

-- order_id chỉ là số giả lập vì đề không yêu cầu bảng Orders
INSERT INTO orderdetail (order_id, product_id, quantity) VALUES
(101, 1, 2),  -- Laptop: 25m * 2 = 50m
(102, 2, 1),  -- iPhone: 22m * 1 = 22m
(103, 3, 3),  -- Bàn: 3m * 3 = 9m
(104, 4, 5),  -- Ghế: 1.6m * 5 = 8m
(105, 5, 10), -- Chuột: 0.3m * 10 = 3m
(106, 6, 2);  -- Tai nghe: 4.5m * 2 = 9m

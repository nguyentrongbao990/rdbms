-- 01_create_database.sql

-- Part A: run on DB postgres
CREATE DATABASE "StoreDB";

-- Part B: run on DB StoreDB
CREATE TABLE IF NOT EXISTS product (
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(100),
    category VARCHAR(50),
    price    NUMERIC(10,2),
    stock    INT
);

-- 1) Thêm 5 sản phẩm (INSERT)
INSERT INTO product (name, category, price, stock) VALUES
('Laptop Dell XPS 13', 'Điện tử', 25000000, 12),
('iPhone 15',          'Điện tử', 22000000, 8),
('Tai nghe AirPods 3', 'Điện tử', 4500000,  20),
('Bàn học gỗ',         'Nội thất', 3000000,  15),
('Ghế xoay',           'Nội thất', 1600000,  30);

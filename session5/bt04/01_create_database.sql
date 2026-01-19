-- 01_create_database.sql

-- Part A: run on DB postgres
CREATE DATABASE "OnlineStoreDB";

-- Part B: run on DB OnlineStoreDB
CREATE TABLE IF NOT EXISTS customers (
    customer_id   SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    city          VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id      SERIAL PRIMARY KEY,
    customer_id   INT REFERENCES customers(customer_id),
    order_date    DATE,
    total_amount  NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS order_items (
    item_id       SERIAL PRIMARY KEY,
    order_id      INT REFERENCES orders(order_id),
    product_name  VARCHAR(100),
    quantity      INT,
    price         NUMERIC(10,2)
);

-- Sample data
INSERT INTO customers (customer_id, customer_name, city) VALUES
(1, 'Nguyễn Văn A', 'Hà Nội'),
(2, 'Trần Thị B',   'Đà Nẵng'),
(3, 'Lê Văn C',     'Hồ Chí Minh'),
(4, 'Phạm Thị D',   'Hà Nội')
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(101, 1, '2024-12-20', 12000.00),
(102, 2, '2025-01-05',  8000.00),
(103, 1, '2025-02-10',  9500.00),
(104, 3, '2025-02-15', 15000.00),
(105, 4, '2025-03-01',  2000.00)
ON CONFLICT (order_id) DO NOTHING;

INSERT INTO order_items (item_id, order_id, product_name, quantity, price) VALUES
(1, 101, 'Laptop Dell', 1, 12000.00),
(2, 102, 'Chuột Logitech', 2, 4000.00),
(3, 103, 'Bàn phím cơ', 1, 9500.00),
(4, 104, 'iPhone 15', 1, 15000.00),
(5, 105, 'Tai nghe', 2, 1000.00)
ON CONFLICT (item_id) DO NOTHING;

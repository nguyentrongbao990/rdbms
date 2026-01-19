-- 02_queries.sql
-- Run on DB: OrderDB

-- 1) Thêm 5 đơn hàng mẫu với tổng tiền khác nhau
INSERT INTO orderinfo (customer_id, order_date, total, status) VALUES
(1, '2024-10-02', 300000.00, 'Pending'),
(2, '2024-10-05', 750000.00, 'Completed'),
(3, '2024-09-28', 520000.00, 'Processing'),
(4, '2024-10-15', 1200000.00,'Completed'),
(5, '2024-10-20', 450000.00, 'Cancelled');

-- 2) Các đơn hàng có tổng tiền > 500,000
SELECT *
FROM orderinfo
WHERE total > 500000
ORDER BY total DESC;

-- 3) Các đơn hàng có ngày đặt trong tháng 10 năm 2024
-- (từ 2024-10-01 đến 2024-10-31)
SELECT *
FROM orderinfo
WHERE order_date BETWEEN '2024-10-01' AND '2024-10-31'
ORDER BY order_date;

-- 4) Các đơn hàng có trạng thái khác "Completed"
SELECT *
FROM orderinfo
WHERE status <> 'Completed'
ORDER BY order_date DESC;

-- 5) Lấy 2 đơn hàng mới nhất (mới nhất = order_date gần nhất)
SELECT *
FROM orderinfo
ORDER BY order_date DESC, id DESC
LIMIT 2;

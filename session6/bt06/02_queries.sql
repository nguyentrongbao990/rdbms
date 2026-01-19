-- 02_queries.sql
-- Run on DB: RevenueDB

-- 1) Tổng doanh thu, số đơn hàng, giá trị trung bình mỗi đơn (ALIAS theo đề)
SELECT
    SUM(total_amount) AS total_revenue,
    COUNT(id)         AS total_orders,
    AVG(total_amount) AS average_order_value
FROM orders;

-- 2) Nhóm dữ liệu theo năm đặt hàng, hiển thị tổng doanh thu từng năm
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    SUM(total_amount)             AS total_revenue
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY order_year;

-- 3) Chỉ hiển thị các năm có doanh thu trên 50 triệu (HAVING)
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    SUM(total_amount)             AS total_revenue
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date)
HAVING SUM(total_amount) > 50000000
ORDER BY total_revenue DESC;

-- 4) Hiển thị 5 đơn hàng có giá trị cao nhất (ORDER BY + LIMIT)
SELECT
    id,
    customer_id,
    order_date,
    total_amount
FROM orders
ORDER BY total_amount DESC
LIMIT 5;

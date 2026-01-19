-- 02_query.sql
-- Run on DB: CustomerRevenueDB
-- 1) Tổng doanh thu và tổng số đơn hàng mỗi khách hàng
-- Chỉ hiển thị khách hàng có tổng doanh thu > 2000
SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_price) AS total_revenue,
    COUNT(o.order_id)  AS order_count
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_price) > 2000
ORDER BY total_revenue DESC;


-- 2) Subquery: doanh thu trung bình của tất cả khách hàng
-- Sau đó hiển thị khách hàng có doanh thu lớn hơn trung bình đó
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.total_price) AS total_revenue
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name
),
avg_revenue AS (
    SELECT AVG(total_revenue) AS avg_total_revenue
    FROM customer_revenue
)
SELECT
    cr.customer_id,
    cr.customer_name,
    cr.total_revenue
FROM customer_revenue cr
CROSS JOIN avg_revenue ar
WHERE cr.total_revenue > ar.avg_total_revenue
ORDER BY cr.total_revenue DESC;


-- 3) HAVING + GROUP BY: lọc ra khách hàng có tổng doanh thu cao nhất
-- (Xử lý cả trường hợp đồng hạng cao nhất)
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.total_price) AS total_revenue
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_revenue
FROM customer_revenue
WHERE total_revenue = (SELECT MAX(total_revenue) FROM customer_revenue);


-- 4) (Mở rộng) INNER JOIN customers, orders, order_items:
-- Tên khách hàng, thành phố, tổng sản phẩm đã mua (sum quantity), tổng chi tiêu
SELECT
    c.customer_name,
    c.city,
    COALESCE(SUM(oi.quantity), 0) AS total_items_bought,
    COALESCE(SUM(oi.quantity * oi.price), 0) AS total_spent
FROM customers c
JOIN orders o      ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_name, c.city
ORDER BY total_spent DESC;

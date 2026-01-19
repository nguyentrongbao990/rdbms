-- 02_query.sql
-- [Giỏi] Online store analytics
-- Run on DB: OnlineStoreDB

-- 1) ALIAS: danh sách tất cả đơn hàng: customer_name, order_date, total_amount
SELECT
    c.customer_name AS customer_name,
    o.order_date    AS order_date,
    o.total_amount  AS total_amount
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
ORDER BY o.order_id;


-- 2) Aggregate Functions: SUM, AVG, MAX, MIN, COUNT
SELECT
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_amount,
    MAX(o.total_amount) AS max_order_amount,
    MIN(o.total_amount) AS min_order_amount,
    COUNT(o.order_id)   AS order_count
FROM orders o;


-- 3) GROUP BY / HAVING:
-- 3a) Tổng doanh thu theo thành phố
SELECT
    c.city,
    SUM(o.total_amount) AS city_total_revenue
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY city_total_revenue DESC;

-- 3b) Chỉ hiện thành phố có tổng doanh thu > 10000
SELECT
    c.city,
    SUM(o.total_amount) AS city_total_revenue
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount) > 10000
ORDER BY city_total_revenue DESC;


-- 4) JOIN 3 bảng: liệt kê sản phẩm đã bán kèm customer_name, order_date, quantity, price
SELECT
    c.customer_name,
    o.order_date,
    oi.product_name,
    oi.quantity,
    oi.price
FROM customers c
JOIN orders o      ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
ORDER BY o.order_date, c.customer_name;


-- 5) Subquery: tìm tên khách hàng có tổng doanh thu cao nhất
-- (xử lý cả trường hợp đồng hạng)
WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.total_amount) AS total_spent
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_name,
    total_spent
FROM customer_sales
WHERE total_spent = (SELECT MAX(total_spent) FROM customer_sales);


-- 6) UNION và INTERSECT
-- 6a) UNION: danh sách tất cả thành phố có khách hàng hoặc có đơn hàng
-- (orders join customers để lấy city; UNION tự loại trùng)
(
    SELECT city FROM customers
)
UNION
(
    SELECT c.city
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
);

-- 6b) INTERSECT: thành phố vừa có khách hàng vừa có đơn hàng
(
    SELECT city FROM customers
)
INTERSECT
(
    SELECT c.city
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
);

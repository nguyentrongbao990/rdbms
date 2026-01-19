-- 02_queries.sql
-- Run on DB: CustomerPotentialDB

-- 1) Hiển thị tên khách hàng và tổng tiền đã mua, sắp xếp tổng tiền giảm dần
SELECT
    c.id,
    c.name,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name
ORDER BY total_spent DESC;


-- 2) Tìm khách hàng có tổng chi tiêu cao nhất (Subquery + MAX)
WITH customer_totals AS (
    SELECT
        c.id,
        c.name,
        COALESCE(SUM(o.total_amount), 0) AS total_spent
    FROM customer c
    LEFT JOIN orders o ON o.customer_id = c.id
    GROUP BY c.id, c.name
)
SELECT
    id,
    name,
    total_spent
FROM customer_totals
WHERE total_spent = (SELECT MAX(total_spent) FROM customer_totals);


-- 3) Liệt kê khách hàng chưa từng mua hàng (LEFT JOIN + IS NULL)
SELECT
    c.id,
    c.name
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.id
WHERE o.id IS NULL
ORDER BY c.id;


-- 4) Hiển thị khách hàng có tổng chi tiêu > trung bình của toàn bộ khách hàng
-- (Dùng Subquery trong HAVING)
SELECT
    c.id,
    c.name,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name
HAVING COALESCE(SUM(o.total_amount), 0) >
(
    SELECT AVG(t.total_spent)
    FROM (
        SELECT
            c2.id,
            COALESCE(SUM(o2.total_amount), 0) AS total_spent
        FROM customer c2
        LEFT JOIN orders o2 ON o2.customer_id = c2.id
        GROUP BY c2.id
    ) t
)
ORDER BY total_spent DESC;

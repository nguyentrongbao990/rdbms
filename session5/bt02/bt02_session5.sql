-- 1) Subquery: tìm sản phẩm có doanh thu cao nhất trong orders
-- Hiển thị: product_name, total_revenue
SELECT
    p.product_name,
    r.total_revenue
FROM products p
JOIN (
    SELECT
        product_id,
        SUM(total_price) AS total_revenue
    FROM orders
    GROUP BY product_id
    ORDER BY total_revenue DESC
    LIMIT 1
) r ON r.product_id = p.product_id;


-- 2) Tổng doanh thu theo từng category (JOIN + GROUP BY)
SELECT
    p.category,
    SUM(o.total_price) AS total_sales
FROM products p
JOIN orders o ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;


-- 3) INTERSECT:
-- category của sản phẩm bán chạy nhất (câu 1)
-- giao với các category có tổng doanh thu > 3000
(
	SELECT DISTINCT p.category
    FROM products p
    JOIN (
        SELECT product_id
        FROM orders
        GROUP BY product_id
        ORDER BY SUM(total_price) DESC
        LIMIT 1
    ) best ON best.product_id = p.product_id
)
INTERSECT
(
    SELECT p.category
    FROM products p
    JOIN orders o ON o.product_id = p.product_id
    GROUP BY p.category
    HAVING SUM(o.total_price) > 3000
);

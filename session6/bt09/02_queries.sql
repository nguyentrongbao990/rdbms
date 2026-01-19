-- 02_queries.sql
-- Run on DB: ProductSalesDB

-- Dùng CTE để tái sử dụng: tổng doanh thu theo từng sản phẩm (kể cả sản phẩm chưa bán)
WITH product_sales AS (
    SELECT
        p.id,
        p.name AS product_name,
        p.category,
        COALESCE(SUM(od.quantity), 0) AS total_quantity,
        COALESCE(SUM(p.price * od.quantity), 0) AS total_sales
    FROM product p
    LEFT JOIN orderdetail od ON od.product_id = p.id
    GROUP BY p.id, p.name, p.category
)

-- 1) Tổng doanh thu từng sản phẩm: product_name, total_sales = SUM(price * quantity)
SELECT
    product_name,
    total_sales
FROM product_sales
ORDER BY total_sales DESC, product_name;


-- 2) Doanh thu trung bình theo từng loại sản phẩm (GROUP BY category)
-- (Hiểu là: trung bình total_sales của các sản phẩm trong category đó)
SELECT
    category,
    ROUND(AVG(total_sales), 2) AS avg_sales
FROM product_sales
GROUP BY category
ORDER BY avg_sales DESC;


-- 3) Chỉ hiện loại sản phẩm có doanh thu trung bình > 20 triệu (HAVING)
SELECT
    category,
    ROUND(AVG(total_sales), 2) AS avg_sales
FROM product_sales
GROUP BY category
HAVING AVG(total_sales) > 20000000
ORDER BY avg_sales DESC;


-- 4) Tên sản phẩm có doanh thu cao hơn doanh thu trung bình toàn bộ sản phẩm (Subquery)
SELECT
    product_name,
    total_sales
FROM product_sales
WHERE total_sales > (SELECT AVG(total_sales) FROM product_sales)
ORDER BY total_sales DESC;


-- 5) Liệt kê toàn bộ sản phẩm và số lượng bán được (kể cả chưa có đơn hàng)
SELECT
    product_name,
    category,
    total_quantity,
    total_sales
FROM product_sales
ORDER BY category, product_name;

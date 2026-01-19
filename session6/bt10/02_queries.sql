-- 02_queries.sql
-- Run on DB: CustomerReportDB

-- 1) Danh sách tất cả khách hàng (cũ + mới) không trùng lặp (UNION)
-- UNION mặc định loại trùng
SELECT name, city
FROM oldcustomers
UNION
SELECT name, city
FROM newcustomers
ORDER BY city, name;


-- 2) Khách hàng vừa thuộc OldCustomers vừa thuộc NewCustomers (INTERSECT)
SELECT name, city
FROM oldcustomers
INTERSECT
SELECT name, city
FROM newcustomers
ORDER BY city, name;


-- 3) Số lượng khách hàng ở từng thành phố (GROUP BY city)
-- Gộp dữ liệu từ cả 2 bảng trước, sau đó GROUP BY
SELECT
    city,
    COUNT(*) AS customer_count
FROM (
    SELECT name, city FROM oldcustomers
    UNION ALL
    SELECT name, city FROM newcustomers
) t
GROUP BY city
ORDER BY customer_count DESC, city;


-- 4) Thành phố có nhiều khách hàng nhất (Subquery + MAX)
WITH city_counts AS (
    SELECT
        city,
        COUNT(*) AS customer_count
    FROM (
        SELECT name, city FROM oldcustomers
        UNION ALL
        SELECT name, city FROM newcustomers
    ) t
    GROUP BY city
)
SELECT
    city,
    customer_count
FROM city_counts
WHERE customer_count = (SELECT MAX(customer_count) FROM city_counts)
ORDER BY city;

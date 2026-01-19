-- 02_queries.sql
-- Run on DB: EmployeeDeptDB

-- 1) Danh sách nhân viên kèm tên phòng ban (INNER JOIN)
SELECT
    e.id,
    e.full_name,
    d.name AS department_name,
    e.salary
FROM employee e
INNER JOIN department d ON d.id = e.department_id
ORDER BY e.id;

-- 2) Lương trung bình theo từng phòng ban (GROUP BY + ALIAS)
SELECT
    d.name AS department_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM department d
JOIN employee e ON e.department_id = d.id
GROUP BY d.name
ORDER BY avg_salary DESC;

-- 3) Phòng ban có lương trung bình > 10 triệu (HAVING)
SELECT
    d.name AS department_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM department d
JOIN employee e ON e.department_id = d.id
GROUP BY d.name
HAVING AVG(e.salary) > 10000000
ORDER BY avg_salary DESC;

-- 4) Phòng ban không có nhân viên nào (LEFT JOIN + WHERE employee.id IS NULL)
SELECT
    d.id,
    d.name AS department_name
FROM department d
LEFT JOIN employee e ON e.department_id = d.id
WHERE e.id IS NULL
ORDER BY d.id;

-- 1) ALIAS: danh sách nhân viên (Tên nhân viên, Phòng ban, Lương)
-- =========================================================
SELECT
    e.emp_name  AS "Tên nhân viên",
    d.dept_name AS "Phòng ban",
    e.salary    AS "Lương"
FROM employees e
JOIN departments d ON d.dept_id = e.dept_id
ORDER BY e.emp_id;

-- =========================================================
-- 2) Aggregate Functions: tổng quỹ lương, lương TB, max/min, số nhân viên
-- =========================================================
SELECT
    SUM(salary)  AS total_salary,
    AVG(salary)  AS avg_salary,
    MAX(salary)  AS max_salary,
    MIN(salary)  AS min_salary,
    COUNT(emp_id) AS employee_count
FROM employees;

-- =========================================================
-- 3) GROUP BY / HAVING:
-- 3a) lương trung bình theo từng phòng ban
-- =========================================================
SELECT
    d.dept_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
JOIN employees e ON e.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY avg_salary DESC;

-- 3b) chỉ hiện phòng ban có lương TB > 15,000,000
SELECT
    d.dept_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
JOIN employees e ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 15000000
ORDER BY avg_salary DESC;

-- =========================================================
-- 4) JOIN: liệt kê dự án + phòng ban phụ trách + nhân viên thuộc phòng ban đó
-- (JOIN 3 bảng: projects, departments, employees)
-- =========================================================
SELECT
    p.project_name,
    d.dept_name,
    e.emp_name,
    e.salary
FROM projects p
JOIN departments d ON d.dept_id = p.dept_id
LEFT JOIN employees e ON e.dept_id = d.dept_id
ORDER BY p.project_id, e.emp_id;

-- =========================================================
-- 5) Subquery: nhân viên có lương cao nhất trong MỖI phòng ban
-- (xử lý cả trường hợp đồng hạng)
-- =========================================================
SELECT
    d.dept_name,
    e.emp_name,
    e.salary
FROM employees e
JOIN departments d ON d.dept_id = e.dept_id
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e.dept_id
)
ORDER BY d.dept_name, e.emp_name;

-- =========================================================
-- 6) UNION và INTERSECT
-- 6a) UNION: phòng ban có nhân viên hoặc có dự án
-- =========================================================
(
    SELECT DISTINCT d.dept_name
    FROM departments d
    JOIN employees e ON e.dept_id = d.dept_id
)
UNION
(
    SELECT DISTINCT d.dept_name
    FROM departments d
    JOIN projects p ON p.dept_id = d.dept_id
)
ORDER BY dept_name;

-- =========================================================
-- 6b) INTERSECT: phòng ban vừa có nhân viên vừa có dự án
-- =========================================================
(
    SELECT DISTINCT d.dept_name
    FROM departments d
    JOIN employees e ON e.dept_id = d.dept_id
)
INTERSECT
(
    SELECT DISTINCT d.dept_name
    FROM departments d
    JOIN projects p ON p.dept_id = d.dept_id
)
ORDER BY dept_name;
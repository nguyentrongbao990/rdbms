-- 02_query.sql
-- [Xuất sắc] Student learning & score analysis
-- Run on DB: StudentScoreDB

-- 1) ALIAS: danh sách sinh viên + môn học + điểm (alias s, c, e)
SELECT
    s.full_name  AS "Tên sinh viên",
    c.course_name AS "Môn học",
    e.score      AS "Điểm"
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN courses c     ON c.course_id = e.course_id
ORDER BY s.student_id, c.course_id;


-- 2) Aggregate Functions: tính cho từng sinh viên (AVG, MAX, MIN)
SELECT
    s.student_id,
    s.full_name,
    ROUND(AVG(e.score), 2) AS avg_score,
    MAX(e.score)           AS max_score,
    MIN(e.score)           AS min_score
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.full_name
ORDER BY avg_score DESC;


-- 3) GROUP BY / HAVING: tìm ngành học (major) có điểm trung bình > 7.5
SELECT
    s.major,
    ROUND(AVG(e.score), 2) AS major_avg_score
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.major
HAVING AVG(e.score) > 7.5
ORDER BY major_avg_score DESC;


-- 4) JOIN 3 bảng: liệt kê sinh viên, môn học, số tín chỉ và điểm
SELECT
    s.full_name,
    s.major,
    c.course_name,
    c.credit,
    e.score
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN courses c     ON c.course_id = e.course_id
ORDER BY s.full_name, c.course_name;


-- 5) Subquery: sinh viên có điểm trung bình > điểm trung bình toàn trường
WITH student_avg AS (
    SELECT
        s.student_id,
        s.full_name,
        AVG(e.score) AS avg_score
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    GROUP BY s.student_id, s.full_name
),
school_avg AS (
    SELECT AVG(avg_score) AS avg_school_score
    FROM student_avg
)
SELECT
    sa.student_id,
    sa.full_name,
    ROUND(sa.avg_score, 2) AS avg_score
FROM student_avg sa
CROSS JOIN school_avg sc
WHERE sa.avg_score > sc.avg_school_score
ORDER BY sa.avg_score DESC;


-- 6) UNION và INTERSECT
-- Điều kiện A: sinh viên có điểm >= 9 (ít nhất 1 môn)
-- Điều kiện B: sinh viên đã học ít nhất 1 môn (có enrollments)

-- 6a) UNION: thỏa A hoặc B
(
    SELECT DISTINCT s.student_id, s.full_name
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    WHERE e.score >= 9
)
UNION
(
    SELECT DISTINCT s.student_id, s.full_name
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
);

-- 6b) INTERSECT: thỏa cả A và B
(
    SELECT DISTINCT s.student_id, s.full_name
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    WHERE e.score >= 9
)
INTERSECT
(
    SELECT DISTINCT s.student_id, s.full_name
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
);

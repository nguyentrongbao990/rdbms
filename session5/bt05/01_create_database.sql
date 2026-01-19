-- 01_create_database.sql

-- Part A: run on DB postgres
CREATE DATABASE "StudentScoreDB";

-- Part B: run on DB StudentScoreDB
CREATE TABLE IF NOT EXISTS students (
    student_id SERIAL PRIMARY KEY,
    full_name  VARCHAR(100),
    major      VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS courses (
    course_id   SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit      INT
);

CREATE TABLE IF NOT EXISTS enrollments (
    student_id INT REFERENCES students(student_id),
    course_id  INT REFERENCES courses(course_id),
    score      NUMERIC(5,2)
);

-- Sample data (đủ để chạy toàn bộ yêu cầu)
INSERT INTO students (student_id, full_name, major) VALUES
(1, 'Nguyễn Văn A', 'IT'),
(2, 'Trần Thị B',   'Business'),
(3, 'Lê Văn C',     'IT'),
(4, 'Phạm Thị D',   'Design'),
(5, 'Đặng Hữu E',   'Business')
ON CONFLICT (student_id) DO NOTHING;

INSERT INTO courses (course_id, course_name, credit) VALUES
(1, 'Database', 3),
(2, 'Java',     4),
(3, 'Marketing',3),
(4, 'UI/UX',    2)
ON CONFLICT (course_id) DO NOTHING;

-- enrollments: mỗi sinh viên có thể học nhiều môn
INSERT INTO enrollments (student_id, course_id, score) VALUES
(1, 1, 8.50),
(1, 2, 9.20),
(2, 3, 7.80),
(2, 1, 6.90),
(3, 1, 7.60),
(3, 2, 7.20),
(4, 4, 8.10),
(4, 1, 7.40),
(5, 3, 9.00)
ON CONFLICT DO NOTHING;

CREATE DATABASE "CompanyHRDB";
-- 1) Tables
CREATE TABLE IF NOT EXISTS departments (
    dept_id   SERIAL PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS employees (
    emp_id    SERIAL PRIMARY KEY,
    emp_name  VARCHAR(100),
    dept_id   INT REFERENCES departments(dept_id),
    salary    NUMERIC(10,2),
    hire_date DATE
);

CREATE TABLE IF NOT EXISTS projects (
    project_id   SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id      INT REFERENCES departments(dept_id)
);

-- 2) Sample data (để chạy ra đủ kết quả UNION/INTERSECT/HAVING)
-- Nếu chạy lại file, xóa dữ liệu cũ trước để không bị trùng
TRUNCATE TABLE departments RESTART IDENTITY CASCADE;

INSERT INTO departments (dept_name) VALUES
('IT'),
('HR'),
('Finance'),
('Sales'),
('R&D');   -- R&D sẽ có dự án nhưng không có nhân viên (để test UNION/INTERSECT)

INSERT INTO employees (emp_name, dept_id, salary, hire_date) VALUES
('Nguyễn Văn A', (SELECT dept_id FROM departments WHERE dept_name='IT'),      18000000, '2021-03-10'),
('Lê Văn B',     (SELECT dept_id FROM departments WHERE dept_name='IT'),      22000000, '2020-11-05'),
('Trần Thị C',   (SELECT dept_id FROM departments WHERE dept_name='HR'),      14000000, '2022-01-15'),
('Phạm Thị D',   (SELECT dept_id FROM departments WHERE dept_name='HR'),      16000000, '2019-07-20'),
('Đặng Văn E',   (SELECT dept_id FROM departments WHERE dept_name='Finance'), 17000000, '2023-02-01'),
('Bùi Thị F',    (SELECT dept_id FROM departments WHERE dept_name='Sales'),   12000000, '2020-09-09');

INSERT INTO projects (project_name, dept_id) VALUES
('Ecommerce Platform', (SELECT dept_id FROM departments WHERE dept_name='IT')),
('HRM System',         (SELECT dept_id FROM departments WHERE dept_name='HR')),
('Cost Optimization',  (SELECT dept_id FROM departments WHERE dept_name='Finance')),
('New Product Lab',    (SELECT dept_id FROM departments WHERE dept_name='R&D'));

-- 01_create_database.sql

-- Part A: run on DB postgres
CREATE DATABASE "EmployeeDeptDB";

-- Part B: run on DB EmployeeDeptDB
CREATE TABLE IF NOT EXISTS department (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS employee (
    id            SERIAL PRIMARY KEY,
    full_name     VARCHAR(100),
    department_id INT,
    salary        NUMERIC(10,2),
    CONSTRAINT fk_employee_department
        FOREIGN KEY (department_id) REFERENCES department(id)
);

-- Sample data (để test phòng ban không có nhân viên)
TRUNCATE TABLE employee RESTART IDENTITY;
TRUNCATE TABLE department RESTART IDENTITY CASCADE;

INSERT INTO department (name) VALUES
('IT'),
('HR'),
('Finance'),
('Marketing'); -- Marketing sẽ không có nhân viên

INSERT INTO employee (full_name, department_id, salary) VALUES
('Nguyễn Văn A', 1, 12000000),
('Trần Thị B',   1,  9000000),
('Lê Văn C',     2, 11000000),
('Phạm Thị D',   3, 15000000);

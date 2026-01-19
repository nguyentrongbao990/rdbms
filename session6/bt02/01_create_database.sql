-- 01_create_database.sql

-- Part A: run on DB postgres
CREATE DATABASE "EmployeePracticeDB";

-- Part B: run on DB EmployeePracticeDB
CREATE TABLE IF NOT EXISTS employee (
    id         SERIAL PRIMARY KEY,
    full_name  VARCHAR(100),
    department VARCHAR(50),
    salary     NUMERIC(10,2),
    hire_date  DATE
);

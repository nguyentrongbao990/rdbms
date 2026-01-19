-- 01_create_database.sql

-- Part A: run on DB postgres
CREATE DATABASE "CourseDB";

-- Part B: run on DB CourseDB
CREATE TABLE IF NOT EXISTS course (
    id         SERIAL PRIMARY KEY,
    title      VARCHAR(100),
    instructor VARCHAR(50),
    price      NUMERIC(10,2),
    duration   INT
);

-- 01_create_database.sql

-- Part A: run on DB postgres
CREATE DATABASE "CustomerPointsDB";

-- Part B: run on DB CustomerPointsDB
CREATE TABLE IF NOT EXISTS customer (
    id     SERIAL PRIMARY KEY,
    name   VARCHAR(100),
    email  VARCHAR(100),
    phone  VARCHAR(20),
    points INT
);

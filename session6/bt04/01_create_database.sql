-- 01_create_database.sql

-- Part A: run on DB postgres
CREATE DATABASE "OrderDB";

-- Part B: run on DB OrderDB
CREATE TABLE IF NOT EXISTS orderinfo (
    id          SERIAL PRIMARY KEY,
    customer_id INT,
    order_date  DATE,
    total       NUMERIC(10,2),
    status      VARCHAR(20)
);

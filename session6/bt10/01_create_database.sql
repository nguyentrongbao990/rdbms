-- 01_create_database.sql

-- =========================
-- Part A: run on DB postgres
-- =========================
CREATE DATABASE "CustomerReportDB";

-- ==========================================
-- Part B: run on DB CustomerReportDB
-- ==========================================

CREATE TABLE IF NOT EXISTS oldcustomers (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS newcustomers (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

-- Sample data (có khách trùng name+city để test INTERSECT)
TRUNCATE TABLE oldcustomers RESTART IDENTITY;
TRUNCATE TABLE newcustomers RESTART IDENTITY;

INSERT INTO oldcustomers (name, city) VALUES
('Nguyễn Văn A', 'Hà Nội'),
('Trần Thị B',   'Đà Nẵng'),
('Lê Văn C',     'Hồ Chí Minh'),
('Phạm Thị D',   'Hà Nội'),
('Hoàng Văn E',  'Hải Phòng');

INSERT INTO newcustomers (name, city) VALUES
('Nguyễn Văn A', 'Hà Nội'),        -- trùng (để INTERSECT ra)
('Lê Văn C',     'Hồ Chí Minh'),   -- trùng
('Đặng Thị F',   'Đà Nẵng'),
('Vũ Văn G',     'Hà Nội'),
('Mai Thị H',    'Cần Thơ');

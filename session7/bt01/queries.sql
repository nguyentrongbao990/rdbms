-- =========================
-- 0) Dọn index để mô phỏng "trước khi tối ưu"
-- ========================
DROP INDEX IF EXISTS idx_book_genre_btree;
DROP INDEX IF EXISTS idx_book_author_trgm;
DROP INDEX IF EXISTS idx_book_fts;

ANALYZE;

-- =========================
-- 1) EXPLAIN ANALYZE TRƯỚC INDEX
-- =========================
EXPLAIN ANALYZE
SELECT *
FROM book
WHERE author ILIKE '%Rowling%';

EXPLAIN ANALYZE
SELECT *
FROM book
WHERE genre = 'Fantasy';

-- =========================
-- 2) TẠO INDEX PHÙ HỢP
-- =========================

-- 2.a) B-tree index cho genre
CREATE INDEX idx_book_genre_btree ON book (genre);

-- 2.b) Tối ưu ILIKE '%...%' cho author:
-- B-tree KHÔNG hiệu quả cho pattern có '%' ở đầu.
-- Dùng pg_trgm + GIN để tăng tốc ILIKE/LIKE dạng contains.
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_book_author_trgm ON book USING GIN (author gin_trgm_ops);

-- 2.c) GIN cho tìm kiếm full-text (title/description)
-- (Index dạng expression)
CREATE INDEX idx_book_fts
ON book
USING GIN (to_tsvector('simple', coalesce(title,'') || ' ' || coalesce(description,'')));

ANALYZE;

-- =========================
-- 3) EXPLAIN ANALYZE SAU INDEX
-- =========================
EXPLAIN ANALYZE
SELECT *
FROM book
WHERE author ILIKE '%Rowling%';

EXPLAIN ANALYZE
SELECT *
FROM book
WHERE genre = 'Fantasy';
-- 4) CLUSTER (Clustered Index) theo genre và so sánh
-- =========================
-- CLUSTER sẽ sắp xếp vật lý bảng theo index 1 lần (khóa bảng trong lúc chạy).
-- Sau CLUSTER nên ANALYZE lại.
CLUSTER book USING idx_book_genre_btree;
ANALYZE;

-- So sánh lại query theo genre sau CLUSTER
EXPLAIN ANALYZE
SELECT *
FROM book
WHERE genre = 'Fantasy';

-- Báo cáo 
-- B-tree hiệu quả nhất cho truy vấn so sánh (=, <, >) và ORDER BY theo cột; ví dụ genre='Fantasy'.
-- ILIKE '%Rowling%' không tận dụng tốt B-tree vì có wildcard ở đầu; GIN + pg_trgm (gin_trgm_ops) thường nhanh hơn rõ rệt.
-- GIN Full-text (to_tsvector + tsquery) phù hợp tìm kiếm nội dung dài trong title/description; nhanh hơn LIKE '%keyword%'.
-- CLUSTER theo genre cải thiện locality (đọc đĩa ít hơn) cho các truy vấn lọc theo genre, nhưng chỉ là “1 lần”; dữ liệu mới insert sẽ làm mất dần lợi ích.
-- Index tăng tốc SELECT nhưng làm INSERT/UPDATE/DELETE chậm hơn vì phải cập nhật thêm cấu trúc index.
-- Hash index chỉ hỗ trợ so sánh bằng (=), không hỗ trợ ORDER BY/range; đa số trường hợp B-tree vẫn tối ưu/đa dụng hơn nên Hash ít được khuyến nghị dùng.

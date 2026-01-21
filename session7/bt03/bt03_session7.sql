CREATE TABLE post (
  post_id     SERIAL PRIMARY KEY,
  user_id     INT NOT NULL,
  content     TEXT,
  tags        TEXT[],
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_public   BOOLEAN DEFAULT TRUE
);

CREATE TABLE post_like (
  user_id INT NOT NULL,
  post_id INT NOT NULL,
  liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, post_id)
);
--Tối ưu hóa truy vấn tìm kiếm bài đăng công khai theo từ khóa:
EXPLAIN ANALYZE
SELECT *
FROM post
WHERE is_public = TRUE
  AND content ILIKE '%du lịch%';
--Seq Scan on post  (cost=0.00..19.25 rows=1 width=81) (actual time=0.006..0.007 rows=0.00 loops=1)
--Tạo Expression Index sử dụng LOWER(content) để tăng tốc tìm kiếm
	--bật extension
create extension pg_trgm;
	--tạo partial + expression + GIN trigram index
create index idx_post_public_content_trgm on
post using gin (lower(content) gin_trgm_ops)
where is_public = true;
	-- chạy lại sau khi đã có index
ANALYZE post;
EXPLAIN ANALYZE
SELECT *
FROM post
WHERE is_public = TRUE
  AND lower(content) LIKE '%du lịch%';
--2)Tối ưu hóa truy vấn lọc bài đăng theo thẻ (tags):
--trước khi tạo index
explain analyze
select * from post where tags @> array['travel'];
--tạo gin index
create index idx_post_tags_gin on
post using gin(tags);
--chạy lại
EXPLAIN ANALYZE
SELECT * FROM post
WHERE tags @> ARRAY['travel'];
--3)Tối ưu hóa truy vấn tìm bài đăng mới trong 7 ngày gần nhất
--Tạo Partial Index cho bài viết công khai gần đây:
create index idx_post_recent_public
on post(created_at desc)
where is_public = true;
--truy van
EXPLAIN ANALYZE
SELECT *
FROM post
WHERE is_public = TRUE
  AND created_at >= NOW() - INTERVAL '7 days'
--4) Phân tích chỉ mục tổng hợp (Composite Index)
--Tạo chỉ mục (user_id, created_at DESC)
CREATE INDEX idx_post_user_created_at
ON post (user_id, created_at DESC);

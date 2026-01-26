create schema bt02;
set search_path to bt02;
create table users(
	user_id bigint generated always as identity,
	email text not null,
	user_name text not null
);
-- tạo dữ liệu mẫu
INSERT INTO users (email, user_name)
SELECT
  'user' || gs || '@example.com',
  'user_' || gs
FROM generate_series(1, 1000000) AS gs;

-- Thêm đúng email bài yêu cầu để test
INSERT INTO users (email, user_name)
VALUES ('example@example.com', 'special_user');
analyze users;

--đo trước khi tạo index
explain analyze
select *
from users
where email = 'example@example.com';
--Gather  (cost=1000.00..15544.44 rows=1 width=41) (actual time=41.597..142.599 rows=1.00 loops=1)
--Execution Time: 142.616 ms

--tạo index
create index idx_user_email_hash on users using hash(email);
analyze users;

--đo lại sau khi tạo index
--Index Scan using idx_user_email_hash on users  (cost=0.00..8.02 rows=1 width=41) (actual time=8.027..8.028 rows=1.00 loops=1)
--Execution Time: 8.051 ms
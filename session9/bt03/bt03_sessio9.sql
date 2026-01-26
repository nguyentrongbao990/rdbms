create schema bt03;
set search_path to bt03;
create table products(
	product_id bigint generated always as identity primary key,
	category_id int not null,
	price numeric(12,2) not null,
	stock_quantity int not null
);
-- dữ liệu mẫu
-- 300,000 dòng (đủ lớn để thấy khác biệt, không quá nặng)
-- Skew: ~25% dữ liệu thuộc category_id = 1
INSERT INTO products (category_id, price, stock_quantity)
SELECT
  CASE
    WHEN random() < 0.25 THEN 1
    ELSE (2 + floor(random() * 199))::int  -- 2..200
  END AS category_id,
  round(((random() * 5000 + 10))::numeric, 2) AS price,    -- 10..5010
  (floor(random() * 500))::int AS stock_quantity           -- 0..499
FROM generate_series(1, 300000);

ANALYZE products;
--Tạo Clustered Index trên cột category_id
create index idx_prod_category_id on products(category_id);
cluster products using idx_prod_category_id;

--Tạo Non-clustered Index trên cột price
create index idx_prod_price on products(price);

--Thực hiện truy vấn SELECT * FROM Products WHERE category_id = X ORDER BY price; và giải thích cách Index hỗ trợ tối ưu
explain analyze
select * from products
where category_id = 1
order by price;
-- trước khi tạo index
--Sort  (cost=11715.46..11902.43 rows=74790 width=22) (actual time=36.433..42.040 rows=74624.00 loops=1)
--Execution Time: 44.755 ms

--sau khi tạo index
--Sort  (cost=9748.38..9935.35 rows=74790 width=22) (actual time=27.304..33.148 rows=74624.00 loops=1)
--Execution Time: 36.119 ms
/* cách index hỗ trợ tối ưu
Index trên category_id giúp lọc nhanh các dòng thuộc category X
CLUSTER theo category_id giúp các dòng cùng category nằm gần nhau về mặt vật lý ⇒ khi đã xác định các dòng của category X, việc đọc từ disk/cache ít “nhảy trang” hơn, đặc biệt khi category đó có nhiều dòng
*/

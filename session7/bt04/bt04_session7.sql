create schema bt04;
set search_path to bt04;
CREATE TABLE customer (
  customer_id SERIAL PRIMARY KEY,
  full_name   VARCHAR(100),
  region      VARCHAR(50)
);
CREATE TABLE orders (
  order_id     SERIAL PRIMARY KEY,
  customer_id  INT REFERENCES customer(customer_id),
  total_amount DECIMAL(10,2),
  order_date   DATE,
  status       VARCHAR(20)
);

CREATE TABLE product (
  product_id SERIAL PRIMARY KEY,
  name       VARCHAR(100),
  price      DECIMAL(10,2),
  category   VARCHAR(50)
);

CREATE TABLE order_detail (
  order_id   INT REFERENCES orders(order_id),
  product_id INT REFERENCES product(product_id),
  quantity   INT,
  PRIMARY KEY (order_id, product_id)
);
--Tạo View tổng hợp doanh thu theo khu vực:
create view v_revenue_by_region as
select c.region, sum(o.total_amount) as total_revenue
from customer c
join orders o on c.customer_id = o.customer_id
group by c.region;
--Viết truy vấn xem top 3 khu vực có doanh thu cao nhất
select region, total_revenue
from v_revenue_by_region
order by total_revenue desc
limit 3;

--2)Tạo View chi tiết đơn hàng có thể cập nhật được:

create or replace view v_orders_updatable as
select
	order_id,
  	customer_id,  
  	total_amount,
  	order_date,
  	status
from orders
where status <> 'cancelled'
with check option;
--Cập nhật status của đơn hàng thông qua View này
update v_orders_updatable
set status ='shipped'
where order_id =1;
--Kiểm tra hành vi khi vi phạm điều kiện WITH CHECK OPTION
update v_orders_updatable
set status ='cancelled'
where order_id=1;
--3)Tạo View phức hợp (Nested View)
	--Từ v_revenue_by_region, tạo View mới v_revenue_above_avg chỉ hiển thị khu vực có doanh thu > trung bình toàn quốc
create or replace view v_revenue_above_avg as
select r.region, r.total_revenue
from v_revenue_by_region r
where r.total_revenue > (select avg(total_revenue) from v_revenue_by_region);
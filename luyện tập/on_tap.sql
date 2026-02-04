/*
Thêm 7 bookings (tự chọn ngày nhưng phải hợp lệ)
Yêu cầu để lát truy vấn có cái mà làm:
Ít nhất 2 booking của cùng 1 khách.
Ít nhất 1 booking có status = Cancelled.
Có booking rơi vào tháng 03/2025 (để mình hỏi lọc theo tháng).
Có 2 booking cùng 1 room nhưng khác thời gian (không trùng).*/
BEGIN;

-- 7 bookings (không cần booking_id vì identity tự tăng)
WITH
b1 AS (
  INSERT INTO bookings (customer_id, room_id, check_in, check_out, status)
  VALUES ('C00101', 'R201', DATE '2025-03-02', DATE '2025-03-05', 'Booked')
  RETURNING booking_id
),
b2 AS (
  INSERT INTO bookings (customer_id, room_id, check_in, check_out, status)
  VALUES ('C00101', 'R201', DATE '2025-03-08', DATE '2025-03-10', 'CheckedIn')
  RETURNING booking_id
),
b3 AS (
  INSERT INTO bookings (customer_id, room_id, check_in, check_out, status)
  VALUES ('C00102', 'R101', DATE '2025-03-15', DATE '2025-03-16', 'Cancelled')
  RETURNING booking_id
),
b4 AS (
  INSERT INTO bookings (customer_id, room_id, check_in, check_out, status)
  VALUES ('C00103', 'R301', DATE '2025-04-01', DATE '2025-04-04', 'Booked')
  RETURNING booking_id
),
b5 AS (
  INSERT INTO bookings (customer_id, room_id, check_in, check_out, status)
  VALUES ('C00104', 'R202', DATE '2025-02-20', DATE '2025-02-22', 'Booked')
  RETURNING booking_id
),
b6 AS (
  INSERT INTO bookings (customer_id, room_id, check_in, check_out, status)
  VALUES ('C00105', 'R302', DATE '2025-03-25', DATE '2025-03-28', 'CheckedIn')
  RETURNING booking_id
),
b7 AS (
  INSERT INTO bookings (customer_id, room_id, check_in, check_out, status)
  VALUES ('C00102', 'R102', DATE '2025-04-10', DATE '2025-04-12', 'Booked')
  RETURNING booking_id
)

-- booking_services cho ít nhất 6 booking (bỏ qua b3 Cancelled cho hợp lý)
INSERT INTO booking_services (booking_id, service_id, quantity)
VALUES
  -- b1: 2 dịch vụ (có quantity=1 để lát bạn test câu DELETE)
  ((SELECT booking_id FROM b1), 'S001', 2),  -- Breakfast x2
  ((SELECT booking_id FROM b1), 'S002', 1),  -- Laundry x1

  -- b2: có dịch vụ qty>1 để sau khi DELETE (qty=1) vẫn còn
  ((SELECT booking_id FROM b2), 'S003', 2),  -- AirportPickup x2
  ((SELECT booking_id FROM b2), 'S005', 1),  -- Minibar x1

  -- b4: quantity >= 3 (đáp ứng yêu cầu)
  ((SELECT booking_id FROM b4), 'S001', 3),  -- Breakfast x3
  ((SELECT booking_id FROM b4), 'S005', 2),  -- Minibar x2

  -- b5
  ((SELECT booking_id FROM b5), 'S002', 2),  -- Laundry x2

  -- b6: quantity >= 3
  ((SELECT booking_id FROM b6), 'S001', 3),  -- Breakfast x3
  ((SELECT booking_id FROM b6), 'S004', 1),  -- ExtraBed x1

  -- b7: 2 dịch vụ (có qty=1 để test DELETE)
  ((SELECT booking_id FROM b7), 'S001', 2),  -- Breakfast x2
  ((SELECT booking_id FROM b7), 'S002', 1);  -- Laundry x1

COMMIT;
SELECT * FROM bookings ORDER BY booking_id;
SELECT * FROM booking_services ORDER BY booking_id, service_id;

update rooms
set price_per_night = price_per_night *1.1
where room_type = 'Suite';

delete from booking_services
where quantity = 1;

select room_id, room_type, price_per_night
from rooms
order by room_id;

select *
from booking_services
order by booking_id, service_id;

--truy van
--cau 1
/*
Liệt kê tất cả booking gồm:
booking_id, customer_id, full_name, room_id, room_type, check_in, check_out, status
Sắp xếp check_in tăng dần.*/
select bk.booking_id,c.customer_id,c.full_name, r.room_id,r.room_type,bk.check_in,bk.check_out,bk.status
from bookings bk
join customers c on bk.customer_id = c.customer_id
join rooms r on bk.room_id=r.room_id
order by bk.check_in;

--Tính số đêm ở cho từng booking:
--nights = check_out - check_in
--Chỉ lấy booking có status <> 'Cancelled'
select booking_id, (check_out -check_in) as nights
from bookings
where status <> 'Cancelled';
--Top 3 booking có số đêm dài nhất (không tính Cancelled).
--Nếu bằng nhau, ưu tiên check_in sớm hơn.
select bk.booking_id,bk.customer_id,bk.room_id,(bk.check_out-bk.check_in) as nights
from bookings bk
where status <> 'Cancelled'
order by nights desc, bk.check_in asc
limit 3;

--Trong tháng 03/2025, liệt kê tổng số booking theo từng room_type (không tính Cancelled).
--Kết quả: room_type, total_bookings
select
	r.room_type,
	count(*) as total_bookings
from rooms r
join bookings bk on r.room_id = bk.room_id
where bk.status <> 'Cancelled' and bk.check_in >='2025-03-01' and bk.check_in <'2025-04-01'
group by r.room_type
order by total_bookings desc;

--Tính tổng tiền dịch vụ cho từng booking:
--tong_dich_vu = SUM(quantity * unit_price)
--Nếu booking không có dịch vụ thì tổng = 0.
select
	bk.booking_id,
	coalesce(sum(bs.quantity*s.unit_price),0) as tong_dich_vu
from bookings bk
left join booking_services bs on bs.booking_id = bk.booking_id
left join services s on s.service_id = bs.service_id
where bk.status <> 'Cancelled'
group by bk.booking_id
order by tong_dich_vu desc,bk.booking_id asc;

/*
Tạo view vw_booking_cost gồm:
booking_id, customer_id, room_id, nights
room_cost = nights * price_per_night
service_cost = tổng dịch vụ (như câu 5)
total_cost = room_cost + service_cost
Chỉ lấy booking status <> 'Cancelled'.*/

create or replace view vw_booking_cost as
with svc as (
  select
    bs.booking_id,
    sum(bs.quantity * s.unit_price) as service_cost
  from booking_services bs
  join services s on s.service_id = bs.service_id
  group by bs.booking_id
)
select
  bk.booking_id,
  bk.customer_id,
  bk.room_id,
  (bk.check_out - bk.check_in) as nights,
  ((bk.check_out - bk.check_in) * r.price_per_night) as room_cost,
  coalesce(svc.service_cost, 0) as service_cost,
  ((bk.check_out - bk.check_in) * r.price_per_night + coalesce(svc.service_cost, 0)) as total_cost
from bookings bk
join rooms r on r.room_id = bk.room_id
left join svc on svc.booking_id = bk.booking_id
where bk.status <> 'Cancelled';

select * from vw_booking_cost order by booking_id;

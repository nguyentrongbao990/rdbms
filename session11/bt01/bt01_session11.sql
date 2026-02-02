create schema bt01;
set search_path to bt01;
create table flights(
	flight_id serial primary key,
	flight_name varchar(100),
	available_seats int
);

create table bookings(
	booking_id serial primary key,
	flight_id int references flights(flight_id),
	customer_name varchar(100)
);
insert into flights (flight_name, available_seats)
values ('VN123',3),('VN456',2);

/* yeu cau:
Tạo Transaction đặt vé thành công
Bắt đầu transaction bằng BEGIN;
Giảm số ghế của chuyến bay 'VN123' đi 1
Thêm bản ghi đặt vé của khách hàng 'Nguyen Van A'
Kết thúc bằng COMMIT;
Kiểm tra lại dữ liệu bảng flights và bookings*/
BEGIN;

UPDATE flights
SET available_seats = available_seats - 1
WHERE flight_name = 'VN123';

INSERT INTO bookings (flight_id, customer_name)
VALUES (
  (SELECT flight_id FROM flights WHERE flight_name = 'VN123'),
  'Nguyen Van A'
);

COMMIT;

-- kiểm tra
SELECT * FROM flights ORDER BY flight_id;
SELECT * FROM bookings ORDER BY booking_id;
/*
Mô phỏng lỗi và Rollback
Thực hiện lại các bước trên nhưng nhập sai flight_id trong bảng bookings
Gọi ROLLBACK; để hủy toàn bộ thay đổi
Kiểm tra lại dữ liệu và chứng minh rằng số ghế không thay đổi
*/
BEGIN;

UPDATE flights
SET available_seats = available_seats - 1
WHERE flight_name = 'VN123';

-- cố tình sai flight_id để lỗi
INSERT INTO bookings (flight_id, customer_name)
VALUES (999999, 'Nguyen Van A');

ROLLBACK;

-- kiểm tra
SELECT * FROM flights ORDER BY flight_id;
SELECT * FROM bookings ORDER BY booking_id;



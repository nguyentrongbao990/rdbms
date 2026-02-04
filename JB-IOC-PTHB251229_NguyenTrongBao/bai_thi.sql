--tao bang
create table customer(
	customer_id	VARCHAR(5) not null primary key,
	customer_full_name	VARCHAR(100) not null ,
	customer_email	VARCHAR(100) not null unique,
	customer_phone	VARCHAR(15) not null,
	customer_address	VARCHAR(255) not null
);
create table room (
	room_id	VARCHAR(5) not null primary key,
	room_type	VARCHAR(50) not null,
	room_price	DECIMAL(10, 2) not null,
	room_status	VARCHAR(20) not null,
	room_area	INT not null
);
create table booking(
	booking_id	serial not null primary key,
	customer_id	VARCHAR(5) not null references customer(customer_id),
	room_id	VARCHAR(5) not null references room(room_id),
	check_in_date	DATE not null,
	check_out_date	DATE not null,
	total_amount	DECIMAL(10, 2)
);
create table payment(
	payment_id	serial not null primary key,
	booking_id	INT not null references booking(booking_id),
	payment_method	VARCHAR(50) not null,
	payment_date	DATE not null,
	payment_amount	DECIMAL(10, 2)
);
--Chèn dữ liệu
--customer
insert into customer (customer_id,customer_full_name,customer_email,customer_phone,customer_address) values
('C001','Nguyen Anh Tu','tu.nguyen@example.com','0912345678','Hanoi, Vietnam'),
('C002','Tran Thi Mai','mai.tran@example.com','0923456789','Ho Chi Minh, Vietnam'),
('C003','Le Minh Hoang','hoang.le@example.com','0934567890','Danang, Vietnam'),
('C004','Pham Hoang Nam','nam.pham@example.com','0945678901','Hue, Vietnam'),
('C005','Vu Minh Thu','thu.vu@example.com','0956789012','Hai Phong, Vietnam');
--room
insert into room(room_id,room_type,room_price,room_status,room_area) values
('R001','Single',100.0,'Available',25),
('R002','Double',150.0,'Booked',40),
('R003','Suite',250.0,'Available',50),
('R004','Single',120.0,'Booked',30),
('R005','Double',160.0,'Available',35);
--booking
insert into booking(customer_id,room_id,check_in_date,check_out_date,total_amount) values
('C001','R001','2025-03-01','2025-03-05',400.0),
('C002','R002','2025-03-02','2025-03-06',600.0),
('C003','R003','2025-03-03','2025-03-07',1000.0),
('C004','R004','2025-03-04','2025-03-08',480.0),
('C005','R005','2025-03-05','2025-03-09',800.0);
--payment
insert into payment (booking_id,payment_method,payment_date,payment_amount) values
(1,'Cash','2025-03-05',400.0),
(2,'Credit Card','2025-03-06',600.0),
(3,'Bank Transfer','2025-03-07',1000.0),
(4,'Cash','2025-03-08',480.0),
(5,'Credit Card','2025-03-09',800.0);
--cau 3:
--cau 4:
delete from payment
where payment_method ='Cash' and payment_amount<500;
--cau 5:
select customer_id as "mã khách hàng", customer_full_name as "họ tên", customer_email as "email", customer_phone as "địa chỉ"
from customer
order by customer_full_name asc;
--cau 6:Lấy thông tin các phòng khách sạn gồm mã phòng, loại phòng, giá phòng và diện tích phòng, sắp xếp theo giá phòng giảm dần.
select room_id as "mã phòng", room_type as "loại phòng", room_price as "giá phòng", room_area as "diện tích phòng"
from room
order by room_price desc;
--cau 7:Lấy thông tin khách hàng và phòng khách sạn đã đặt, gồm mã khách hàng, họ tên khách hàng, mã phòng, ngày nhận phòng và ngày trả phòng.
select c.customer_id as "mã khách hàng",c.customer_full_name as "họ tên khách hàng",r.room_id as "mã phòng",bk.check_in_date as "ngày nhận phòng",bk.check_out_date as "ngày trả phòng"
from booking bk
join customer c on c.customer_id=bk.customer_id
join room r on bk.room_id = r.room_id;
--cau 8:
select
	c.customer_id,
	c.customer_full_name,
	p.payment_method,
	p.payment_amount
from customer c
join booking bk on bk.customer_id = c.customer_id
join payment p on bk.booking_id = p.booking_id
order by p.payment_amount desc;
--cau 9:
select *
from customer c
order by c.customer_full_name
limit 3
offset 1;
--cau 10:
select
	c.customer_id,
	c.customer_full_name,
	count(r.room_id) as so_luong_phong_da_dat
from customer c
join booking bk on c.customer_id=bk.customer_id
join room r on bk.room_id = r.room_id
group by c.customer_id
having count(r.room_id) >=2 and sum(bk.total_amount) >1000;
--cau 11:
select
	r.room_id,
	r.room_type,
	r.room_price,
	sum(bk.total_amount) as tong_so_tien_thanh_toan
from room r
join booking bk on bk.room_id = r.room_id
join customer c on bk.customer_id = c.customer_id
group by r.room_id
having sum(bk.total_amount) <1000 and count(c.customer_id)>=3;
--cau 12:
select
	c.customer_id,
	c.customer_full_name,
	bk.room_id,
	sum(bk.total_amount) as tong_so_tien_thanh_toan
from customer c
join booking bk on bk.customer_id = c.customer_id
group by c.customer_id,bk.room_id
having sum(bk.total_amount)>1000;
--cau13
select
	customer_id,
	customer_full_name,
	customer_email,
	customer_phone,
	customer_address
from customer
where customer_full_name ilike '%Minh%'
	or customer_address ilike 'Hanoi%'
order by customer_full_name;
--cau 14:
select
	room_id,
	room_type,
	room_price
from room
order by room_price desc
limit 5 offset 5;
--cau15:
create or replace view v_customer_room as
	select
		r.room_id,
		r.room_type,
		c.customer_id,
		c.customer_full_name
	from customer c
	join booking bk on bk.customer_id = c.customer_id
	join room r on r.room_id = bk.room_id
	where bk.check_in_date < '2025-03-10';
--cau 16:
create or replace view v_customer_room_area as
select
	c.customer_id,
	c.customer_full_name,
	r.room_id,
	r.room_area
from booking bk
join customer c on c.customer_id = bk.customer_id
join room r on r.room_id = bk.room_id
where r.room_area >30;
--cau 17:
create or replace function fn_check_insert_booking()
returns trigger
language plpgsql
as $$
begin
	if new.check_in_date > new.check_out_date then
		raise exception 'Ngày đặt phòng không thể sau ngày trả phòng được !';
	end if;
	return new;
end;
$$;

create trigger check_insert_booking
before insert on booking
for each row
execute function fn_check_insert_booking();

--cau18:
create or replace function fn_update_room_status_on_booking()
returns trigger
language plpgsql
as $$
begin
	update room r
	set r.room_status='Booked'
	where r.room_id=new.room_id;
	return new;
end;
$$;

create trigger update_room_status_on_booking
after insert on booking
for each row
execute function fn_update_room_status_on_booking();
--cau19:
create or replace procedure add_customer (
	p_customer_id varchar(5),
	p_customer_full_name varchar(100),
	p_customer_email varchar(100),
	p_customer_phone varchar(15),
	p_customer_address varchar(255)
)
language plpgsql
as $$
begin
	insert into customer (customer_id,customer_full_name,customer_email,customer_phone,customer_address) values
	(p_customer_id,p_customer_full_name,p_customer_email,p_customer_phone,p_customer_address);
end;
$$;
--cau 20:
create or replace procedure add_payment(
	p_booking_id int,  --Mã đặt phòng (booking_id).
	p_payment_method varchar(50), --Phương thức thanh toán (payment_method).
	p_payment_amount decimal(10,2), --Số tiền thanh toán (payment_amount).
	p_payment_date date --Ngày thanh toán (payment_date).
)
language plpgsql
as $$
begin
	--xac nhan booking_id hop le
	if not exists(
		select 1
		from booking
		where booking_id = p_booking_id
	) then
		raise exception 'booking id khong hop le!';
	end if;
	--chen vao bang payment
	insert into payment(payment_method,payment_amount,payment_date) values
	(p_payment_method,p_payment_amount,p_payment_date);
end;
$$;
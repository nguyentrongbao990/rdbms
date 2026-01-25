-- tạo bảng
create table if not exists order_detail(
	id int generated always as identity primary key,
	order_id int,
	product_name varchar(100),
	quantity int,
	unit_price numeric
);
--insert dữ liệu mẫu
INSERT INTO order_detail (order_id, product_name, quantity, unit_price) VALUES
(10248, 'Pen',        2,  10.00),
(10248, 'Notebook',   1,  25.50),
(10248, 'Eraser',     3,   2.00),
(10249, 'Mouse',      1, 150.00),
(10249, 'Keyboard',   1, 300.00),
(10250, 'USB Cable',  4,  15.00);
--tạo procedure
/*Viết một Stored Procedure có tên calculate_order_total(order_id_input INT, OUT total NUMERIC)
Tham số order_id_input: mã đơn hàng cần tính
Tham số total: tổng giá trị đơn hàng
Trong Procedure:
Viết câu lệnh tính tổng tiền theo order_id*/

create or replace procedure calculate_order_total(
	order_id_input int,
	out total numeric
)
language plpgsql
as $$
begin
	select coalesce(sum(o.quantity*o.unit_price),0) into total
	from order_detail o
	where o.order_id=order_id_input;
	
end;
$$;
--Gọi Procedure để kiểm tra hoạt động với một order_id cụ thể
CALL calculate_order_total(10248,null); -- 51.5
CALL calculate_order_total(10249,null); -- 450
CALL calculate_order_total(10250,null); -- 60
CALL calculate_order_total(99999,null); -- không có dòng nào -> nếu có COALESCE thì ra 0
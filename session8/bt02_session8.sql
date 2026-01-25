create schema bt02;
set search_path to bt02;
--tạo bảng
create table inventory(
	product_id int generated always as identity primary key,
	product_name varchar(100),
	quatity int
);
-- dữ liệu mẫu
INSERT INTO inventory( quatity) VALUES
( 50),   -- nhiều hàng
( 5),    -- ít hàng
( 0);    -- hết hàng
/*Yêu cầu:
Viết một Procedure có tên check_stock(p_id INT, p_qty INT) để:
Kiểm tra xem sản phẩm có đủ hàng không
Nếu quantity < p_qty, in ra thông báo lỗi bằng RAISE EXCEPTION ‘Không đủ hàng trong kho’
Gọi Procedure với các trường hợp:
Một sản phẩm có đủ hàng
Một sản phẩm không đủ hàng*/
create or replace procedure check_stock(
	p_id int,
	p_qty int
)
language plpgsql
as $$
declare
	v_stock int;
begin
	select i.quatity into v_stock
	from inventory i
	where i.product_id = p_id;

	if v_stock is null then raise exception 'San pham khon ton tai';
	elsif v_stock < p_qty then 
		raise exception 'Không đủ hàng trong kho';
	else
		raise notice 'đủ hàng';
	end if;
end;
$$;
-- gọi procedure để test
CALL check_stock(1, 10);  -- Đủ hàng
CALL check_stock(2, 10);  -- Không đủ hàng trong kho (RAISE EXCEPTION)
CALL check_stock(999, 1); -- Sản phẩm không tồn tại (RAISE EXCEPTION)

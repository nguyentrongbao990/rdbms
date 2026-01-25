create schema bt04;
set search_path to bt04;
create table products(
	id serial primary key,
	name varchar(100),
	price numeric,
	discount_percent int
);
INSERT INTO products( name, price, discount_percent) VALUES
( 'A', 1000.00, 10),   -- giảm 10%
( 'B', 2000.00, 60),   -- giảm 60% nhưng bị giới hạn 50%
( 'C',  500.00, 0);    -- không giảm

/*yêu cầu:
viết Procedure calculate_discount(p_id INT, OUT p_final_price NUMERIC) để:
Lấy price và discount_percent của sản phẩm
Tính giá sau giảm:
 p_final_price = price - (price * discount_percent / 100)
Nếu phần trăm giảm giá > 50, thì giới hạn chỉ còn 50%
Cập nhật lại cột price trong bảng products thành giá sau giảm
*/

create procedure calculate_discount(
	p_id int,
	out p_final_price numeric
)
language plpgsql
as $$
declare
	v_price numeric;
	v_discount int;
	v_discount_used int;
begin
	select price, discount_percent
	into v_price, v_discount
	from products
	where id = p_id;

	IF NOT FOUND THEN
    	RAISE EXCEPTION 'Sản phẩm không tồn tại';
  	END IF;

	v_discount_used := case
		when v_discount > 50 then 50
		else v_discount
	end;

	p_final_price := v_price - (v_price*v_discount_used/100.0);

	update products
	set price = p_final_price
	where id=p_id;
end;
$$;
CALL calculate_discount(1,null); -- 900.00
CALL calculate_discount(2,null); -- 1000.00 (giảm 50% của 2000)
CALL calculate_discount(3,null); -- 500.00
CALL calculate_discount(999,null); -- lỗi "Sản phẩm không tồn tại"

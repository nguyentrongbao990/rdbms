-- tạo bảng + dữ liệu mẫu
create schema bt04;
set search_path to bt04;
create table products(
	id bigserial primary key,
	name text not null,
	stock int not null check(stock>=0)
);
create table orders(
	id bigserial primary key,
	product_id bigint not null references products(id),
	quantity int not null check(quantity>0)
);
insert into products(name, stock) values
('pencil', 10),
('notebook', 5);
--trigger function
/*Khi có đơn hàng mới, trừ số lượng tồn kho tương ứng
Khi đơn hàng bị chỉnh sửa, cập nhật tồn kho tương ứng với sự thay đổi số lượng
Khi đơn hàng bị xóa, trả lại số lượng vào tồn kho*/
create or replace function trg_update_stock()
returns trigger
language plpgsql
as $$
begin
	if tg_op= 'INSERT' then
		update products
		set stock = stock - new.quantity
		where id = new.product_id and stock-new.quantity>=0;

		if not found then
			raise exception 'stock khong du';
		end if;
		return new;
	elsif tg_op='DELETE' then
		update products
		set stock= stock + old.quantity
		where id= old.product_id;
		return old;
	else
		update products 
		set stock=stock - (new.quantity - old.quantity)
		where id=new.product_id and
			stock-(new.quantity-old.quantity) >=0;
		if not found then
			raise exception 'Stock ko du';
		end if;
		return new;
	end if;
end;
$$;
--tao trigger
create trigger update_stock
after insert or update or delete on orders
for each row
execute function trg_update_stock();

--test
select * from products order by id;
-- insert đơn: trừ kho
insert into orders(product_id, quantity) values (1, 3);
select * from products order by id;
--1	"pencil"	7
--2	"notebook"	5
-- update tăng số lượng: trừ thêm
update orders set quantity = 5 where id = 2;
select * from products order by id;
--1	"pencil"	5
--2	"notebook"	5
-- delete đơn: hoàn kho
delete from orders where id = 2;
select * from products order by id;
--1	"pencil"	10
--2	"notebook"	5
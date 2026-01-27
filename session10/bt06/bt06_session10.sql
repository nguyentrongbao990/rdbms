--tao bang + dư liệu mẫu
create schema bt06;
set search_path to bt06;
create table products(
	id bigserial primary key,
	name text not null,
	stock int not null check(stock>=0)
);
create table orders(
	id bigserial primary key,
	product_id bigint not null references products(id),
	quantity int not null check(quantity >0),
	order_status text not null default 'new'
);
insert into products(name, stock) values
('pencil', 10),
('notebook', 5),
('mouse', 2);

--trigger function
create or replace function trg_sync_stock()
returns trigger
language plpgsql
as $$
declare
  old_reserved int;
  new_reserved int;
begin
  if tg_op = 'INSERT' then
    new_reserved := case when new.order_status <> 'cancelled' then new.quantity else 0 end;

    if new_reserved > 0 then
      update products
      set stock = stock - new_reserved
      where id = new.product_id
        and stock - new_reserved >= 0;

      if not found then
        raise exception 'insufficient stock';
      end if;
    end if;

    return new;

  elsif tg_op = 'DELETE' then
    old_reserved := case when old.order_status <> 'cancelled' then old.quantity else 0 end;

    if old_reserved > 0 then
      update products
      set stock = stock + old_reserved
      where id = old.product_id;
    end if;

    return old;

  else
    -- update
    new_reserved := case when new.order_status <> 'cancelled' then new.quantity else 0 end;
    old_reserved := case when old.order_status <> 'cancelled' then old.quantity else 0 end;

    if new.product_id = old.product_id then
      update products
      set stock = stock - (new_reserved - old_reserved)
      where id = new.product_id
        and stock - (new_reserved - old_reserved) >= 0;

      if not found then
        raise exception 'insufficient stock';
      end if;

    else
      -- hoàn kho product cũ
      if old_reserved > 0 then
        update products
        set stock = stock + old_reserved
        where id = old.product_id;
      end if;

      -- trừ kho product mới
      if new_reserved > 0 then
        update products
        set stock = stock - new_reserved
        where id = new.product_id
          and stock - new_reserved >= 0;

        if not found then
          raise exception 'insufficient stock';
        end if;
      end if;
    end if;

    return new;
  end if;
end;
$$;
-- tao trigger
create trigger trg_orders_sync_stock
after insert or update or delete on orders
for each row
execute function trg_sync_stock();

--test
select * from products order by id;
select * from orders order by id;
--insert hợp lệ (trừ kho)
insert into orders(product_id, quantity, order_status)
values (1, 3, 'new'); -- pencil: 10 -> 7
--update tăng quantity (trừ thêm)
update orders
set quantity = 5
where id = 1; -- pencil: 7 -> 5 (trừ thêm 2)
--update giảm quantity (hoàn lại)
update orders
set quantity = 2
where id = 1; -- pencil: 5 -> 8 (hoàn 3)
--cancel đơn (hoàn kho)
update orders
set order_status = 'cancelled'
where id = 1; -- pencil: 8 -> 10
--delete đơn đã cancelled (không hoàn thêm)
delete from orders
where id = 1;          -- pencil giữ 10
--oversell (bị chặn)
insert into orders(product_id, quantity, order_status)
values (3, 999, 'new');  -- mouse stock=2 -> raise exception
--đổi product_id (chuyển đơn từ pencil sang notebook)
	-- tạo đơn mới để chuyển
	insert into orders(product_id, quantity, order_status)
	values (1, 4, 'new');   -- pencil: 10 -> 6
	
	-- chuyển sang notebook
	update orders
	set product_id = 2
	where id = 3;           -- pencil: +4 (6->10), notebook: -4 (5->1)
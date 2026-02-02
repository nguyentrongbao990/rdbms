create schema bt06;
set search_path to bt06;

-- tao bang accounts
create table accounts (
  account_id serial primary key,
  account_name varchar(50),
  balance numeric(12,2)
);

-- them 2 tai khoan mau
insert into accounts (account_name, balance)
values
  ('a', 500.00),
  ('b', 300.00);

-- kiem tra du lieu ban dau
select * from accounts order by account_id;

do $$
declare
  v_from_id int := 1;            -- tai khoan gui (a)
  v_to_id   int := 2;            -- tai khoan nhan (b)
  v_amount  numeric(12,2) := 100.00;
  v_balance numeric(12,2);
begin
  -- bat dau transaction (do $$ tu chay trong 1 transaction)
  -- (1) lay so du tai khoan gui
  select balance into v_balance
  from accounts
  where account_id = v_from_id;

  if not found then
    raise exception 'tai khoan gui khong ton tai';
  end if;

  -- (2) kiem tra du tien
  if v_balance < v_amount then
    raise exception 'khong du so du de chuyen tien';
  end if;

  -- (3) tru tien tai khoan gui
  update accounts
  set balance = balance - v_amount
  where account_id = v_from_id;

  -- (4) cong tien tai khoan nhan (neu tai khoan nhan khong ton tai => loi => rollback)
  update accounts
  set balance = balance + v_amount
  where account_id = v_to_id;

  if not found then
    raise exception 'tai khoan nhan khong ton tai';
  end if;

  -- neu khong co exception thi tu dong commit khi ket thuc do block
  raise notice 'chuyen tien thanh cong: % -> % , so tien = %', v_from_id, v_to_id, v_amount;
end $$;

-- xem ket qua sau khi chuyen hop le
select * from accounts order by account_id;

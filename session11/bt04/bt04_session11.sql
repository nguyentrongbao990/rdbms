create schema bt04;
set search_path to bt04;
create table accounts(
	account_id serial primary key,
	customer_name varchar(100),
	balance numeric (12,2)
);
create table transactions (
	trans_id serial primary key,
	account_id int references accounts(account_id),
	amount numeric(12,2),
	trans_type varchar(20),
	created_at timestamp default now()
);

-- du lieu mau
insert into accounts (customer_name, balance)
values ('a', 500.00), ('b', 300.00);

select * from accounts order by account_id;


-- rut 100 tu tai khoan 1
begin;

-- (1) tru tien theo cach an toan:
--     chi tru neu du so du (balance >= 100)
--     update nay la "atomic": vua kiem tra vua cap nhat trong 1 cau lenh
update accounts
set balance = balance - 100.00
where account_id = 1
  and balance >= 100.00;

-- (2) neu update o tren khong cap nhat dong nao (update 0) => khong du tien hoac sai account_id
--     trong pgadmin,message: "update 1" la ok, "update 0" thi rollback
--     neu update 1 thi ghi log giao dich
insert into transactions (account_id, amount, trans_type)
values (1, 100.00, 'withdraw');

commit;

-- kiem tra ket qua
select * from accounts where account_id = 1;
select * from transactions where account_id = 1 order by trans_id desc limit 5;

-- mo phong loi
begin;

-- (1) tru tien (gia su tai khoan 1 du tien)
update accounts
set balance = balance - 100.00
where account_id = 1
  and balance >= 100.00;

-- (2) co tinh ghi log sai account_id (khong ton tai) => se loi fk
insert into transactions (account_id, amount, trans_type)
values (999999, 100.00, 'withdraw');

-- dong duoi day thuong se khong chay duoc vi batch dung tai lenh loi
rollback;

-- kiem tra
select * from accounts where account_id = 1;
select * from transactions order by trans_id desc limit 5;

create schema bt02;
set search_path to bt02;
create table accounts(
	account_id serial primary key,
	owner_name varchar (100),
	balance numeric (10,2)
);
insert into accounts (owner_name, balance) values
('A', 500.00),('B',300.00);

SELECT account_id, owner_name, balance
FROM accounts
ORDER BY account_id;
/*
Thực hiện giao dịch chuyển tiền hợp lệ
Dùng BEGIN; để bắt đầu transaction
Cập nhật giảm số dư của A, tăng số dư của B
Dùng COMMIT; để hoàn tất
Kiểm tra số dư mới của cả hai tài khoản
*/
begin;
--tru tien tai khoan A
update accounts
set balance = balance -100.00
where owner_name = 'A';
--cong tien tai khoan B
update accounts
set balance = balance +100.00
where owner_name = 'B';

commit;
rollback;
--kiem tra lai so du
select owner_name, balance
from accounts
where owner_name in ('A','B')
order by owner_name;
/*
Thử mô phỏng lỗi và Rollback
Lặp lại quy trình trên, nhưng cố ý nhập sai account_id của người nhận
Gọi ROLLBACK; khi xảy ra lỗi
Kiểm tra lại số dư, đảm bảo không có thay đổi
*/
BEGIN;

-- Trừ tiền A
UPDATE accounts
SET balance = balance - 100.00
WHERE owner_name = 'A';

-- Cố tình sai người nhận (không có owner_name = 'C')
UPDATE accounts
SET balance = balance + 100.00
WHERE owner_name = 'C';

rollback;
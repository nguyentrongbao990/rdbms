-- them cot genre vao books
alter table library.books
add column genre varchar(100);
-- doi ten cot available thanh is_available
alter table library.books
rename column available to is_available;
-- xoa cot email ra khoi members
alter table library.members
drop column email;
-- xoa bang OrderDetails khoi schema sales
drop table sales.orderdetails;
create schema sales;
create table sales.Products(
	product_id serial primary key,
	product_name varchar(200) not null,
	price numeric(10,2) not null check(price>0),
	stock_quantity int check (stock_quantity>0)
);
create table sales.orders(
	order_id serial primary key,
	order_date date default current_date,
	member_id int references library.members(member_id)
);
create table sales.orderdetails(
	order_detail_id serial primary key,
	order_id int references sales.orders(order_id),
	product_id int references sales.products(product_id)
);
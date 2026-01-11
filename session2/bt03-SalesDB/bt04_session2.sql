create schema sales;
create table sales.customers(
	customer_id int generated always as identity primary key,
	first_name varchar(50) not null,
	last_name varchar (50) not null,
	email varchar(255) not null unique,
	phone varchar(20)
);
create table sales.products(
	product_id int generated always as identity primary key,
	product_name varchar(100) not null,
	price numeric(12,2) not null check (price >=0),
	stock_quantity int not null check(stock_quantity>=0)
);
create table sales.orders(
	order_id int generated always as identity primary key,
	customer_id int references sales.customers(customer_id),
	order_date date not null
);
create table sales.orderItems(
	order_item_id int generated always as identity primary key,
	order_id int references sales.orders(order_id),
	product_id int references sales.products(product_id),
	quantity int not null check (quantity >=1)
);

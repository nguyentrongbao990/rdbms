create table library.books(
	book_id int generated always as identity primary key,
	title text not null,
	author text not null,
	published_year int not null,
	available boolean default true
);
create table library.members(
	member_id int primary key,
	name varchar(200) not null,
	email varchar(255) unique,
	join_date date default current_date
);
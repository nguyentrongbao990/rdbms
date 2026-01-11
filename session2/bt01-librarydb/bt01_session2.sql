create schema if not exists library;
create table if not exists library."Books"(
	book_id int generated always as identity primary key,
	title varchar(100) not null,
	author varchar(50) not null,
	published_year int,
	price numeric
);
-- Xem tat ca cac DB
select datname
from pg_database
order by datname;
-- Xem tat ca schema trong LibraryDB
select schema_name
from information_schema.schemata
order by schema_name;
-- xem cau truc bang library.Books
select *
from information_schema.columns
where table_schema = 'library'
and table_name = 'Books'
order by ordinal_position;


-- tạo bảng
create table if not exists customer (
    customer_id serial primary key,
    full_name varchar(100),
    email varchar(100),
    phone varchar(15)
);

create table if not exists orders (
    order_id serial primary key,
    customer_id int references customer(customer_id),
    total_amount decimal(10,2),
    order_date date
);

-- xóa dữ liệu cũ
delete from orders;
delete from customer;
alter sequence customer_customer_id_seq restart with 1;
alter sequence orders_order_id_seq restart with 1;

-- chèn dữ liệu
insert into customer (full_name, email, phone) values
('Nguyễn Văn An', 'an.nguyen@email.com', '0912345678'),
('Trần Thị Bích', 'bich.tran@email.com', '0923456789'),
('Lê Hoàng Cường', 'cuong.le@email.com', '0934567890'),
('Phạm Thị Dung', 'dung.pham@email.com', '0945678901'),
('Hoàng Văn Em', 'em.hoang@email.com', '0956789012');

insert into orders (customer_id, total_amount, order_date) values
(1, 250000.00, '2024-01-15'),
(2, 180000.00, '2024-02-20'),
(3, 320000.00, '2024-03-10'),
(4, 420000.00, '2024-03-18'),
(5, 280000.00, '2024-04-05'),
(1, 350000.00, '2024-04-12'),
(2, 190000.00, '2024-05-20'),
(3, 480000.00, '2024-05-08');

-- tạo view v_order_summary
create or replace view v_order_summary as
select 
    c.full_name,
    o.total_amount,
    o.order_date
from customer c
join orders o on c.customer_id = o.customer_id;

-- xem dữ liệu từ view
select * from v_order_summary;

-- tạo view updateable cho orders
create or replace view v_orders_updateable as
select order_id, customer_id, total_amount, order_date 
from orders
with check option;

-- test update qua view
update v_orders_updateable set total_amount = 275000.00 where order_id = 1;

-- tạo view thống kê theo tháng
create or replace view v_monthly_sales as
select 
    extract(year from order_date) as nam,
    extract(month from order_date) as thang,
    to_char(order_date, 'yyyy-mm') as thang_nam,
    count(*) as so_don_hang,
    sum(total_amount) as tong_doanh_thu
from orders
group by extract(year from order_date), extract(month from order_date), to_char(order_date, 'yyyy-mm')
order by nam, thang;

-- xem thống kê
select * from v_monthly_sales;

-- tạo materialized view để so sánh
create materialized view mv_monthly_sales as
select * from v_monthly_sales;

-- demo drop
drop view if exists v_orders_updateable;
drop materialized view if exists mv_monthly_sales;
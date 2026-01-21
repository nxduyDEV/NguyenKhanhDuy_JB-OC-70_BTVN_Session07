-- tạo bảng
create table if not exists customer (
    customer_id serial primary key,
    full_name varchar(100),
    region varchar(50)
);

create table if not exists orders (
    order_id serial primary key,
    customer_id int references customer(customer_id),
    total_amount decimal(10,2),
    order_date date,
    status varchar(20)
);

create table if not exists product (
    product_id serial primary key,
    name varchar(100),
    price decimal(10,2),
    category varchar(50)
);

create table if not exists order_detail (
    order_id int references orders(order_id),
    product_id int references product(product_id),
    quantity int
);

-- xóa dữ liệu cũ
delete from order_detail;
delete from orders;
delete from customer;
delete from product;
alter sequence customer_customer_id_seq restart with 1;
alter sequence orders_order_id_seq restart with 1;
alter sequence product_product_id_seq restart with 1;

-- chèn dữ liệu mẫu
insert into customer (full_name, region) values
('Nguyễn Văn An', 'Miền Bắc'),
('Trần Thị Bích', 'Miền Nam'),
('Lê Hoàng Cường', 'Miền Trung'),
('Phạm Thị Dung', 'Miền Bắc'),
('Hoàng Văn Em', 'Miền Nam');

insert into product (name, price, category) values
('iPhone 15', 25000000.00, 'Điện thoại'),
('MacBook Air M2', 35000000.00, 'Laptop'),
('iPad Pro', 22000000.00, 'Tablet'),
('AirPods Pro', 6000000.00, 'Phụ kiện'),
('Apple Watch', 12000000.00, 'Đồng hồ');

insert into orders (customer_id, total_amount, order_date, status) values
(1, 31000000.00, '2024-01-15', 'Completed'),
(2, 57000000.00, '2024-02-20', 'Completed'),
(3, 22000000.00, '2024-03-10', 'Completed'),
(4, 18000000.00, '2024-04-18', 'Pending'),
(5, 47000000.00, '2024-05-05', 'Completed'),
(1, 25000000.00, '2024-06-12', 'Completed');

insert into order_detail (order_id, product_id, quantity) values
(1, 1, 1), (1, 4, 1),
(2, 2, 1), (2, 3, 1),
(3, 3, 1),
(4, 4, 3),
(5, 2, 1), (5, 5, 1),
(6, 1, 1);

-- tạo view doanh thu theo khu vực
create or replace view v_revenue_by_region as
select 
    c.region,
    sum(o.total_amount) as total_revenue,
    count(o.order_id) as total_orders
from customer c
join orders o on c.customer_id = o.customer_id
where o.status = 'Completed'
group by c.region;

-- top 3 khu vực doanh thu cao nhất
select * from v_revenue_by_region order by total_revenue desc limit 3;

-- tạo materialized view theo tháng
create materialized view mv_monthly_sales as
select 
    date_trunc('month', order_date) as month,
    sum(total_amount) as monthly_revenue
from orders
where status = 'Completed'
group by date_trunc('month', order_date);

-- tạo updatable view
create or replace view v_order_management as
select order_id, customer_id, total_amount, order_date, status
from orders
with check option;

-- test update qua view
update v_order_management set status = 'Completed' where order_id = 4;

-- tạo nested view - khu vực trên trung bình
create or replace view v_national_avg as
select avg(total_revenue) as national_avg_revenue from v_revenue_by_region;

create or replace view v_revenue_above_avg as
select r.region, r.total_revenue
from v_revenue_by_region r
cross join v_national_avg n
where r.total_revenue > n.national_avg_revenue;

-- xem kết quả
select * from v_revenue_above_avg;

-- refresh và drop materialized view
refresh materialized view mv_monthly_sales;
drop materialized view mv_monthly_sales;
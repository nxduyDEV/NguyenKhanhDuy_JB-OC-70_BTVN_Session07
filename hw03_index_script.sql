-- tạo bảng
create table if not exists post (
    post_id serial primary key,
    user_id int not null,
    content text,
    tags text[],
    created_at timestamp default current_timestamp,
    is_public boolean default true
);

create table if not exists post_like (
    user_id int not null,
    post_id int not null,
    liked_at timestamp default current_timestamp,
    primary key (user_id, post_id)
);

-- xóa dữ liệu cũ
delete from post_like;
delete from post;
alter sequence post_post_id_seq restart with 1;

-- chèn dữ liệu
insert into post (user_id, content, tags, created_at, is_public) values
(1, 'hôm nay tôi đi du lịch đà nẵng rất vui', array['travel', 'danang'], current_timestamp - interval '1 day', true),
(2, 'chia sẻ kinh nghiệm du lịch sài gòn', array['travel', 'saigon'], current_timestamp - interval '2 days', true),
(3, 'học lập trình postgresql rất thú vị', array['programming', 'database'], current_timestamp - interval '3 days', true),
(4, 'du lịch hạ long bay tuyệt đẹp', array['travel', 'halongbay'], current_timestamp - interval '5 days', true),
(5, 'học database index optimization', array['programming', 'optimization'], current_timestamp - interval '6 days', true);

insert into post_like (user_id, post_id) values
(2, 1), (3, 1), (4, 2), (1, 3), (5, 4);

-- test truy vấn trước khi có index
explain analyze select * from post where is_public = true and content ilike '%du lich%';
explain analyze select * from post where tags @> array['travel'];
explain analyze select * from post where is_public = true and created_at >= now() - interval '7 days';

-- tạo các index nâng cao
create index idx_post_content_lower on post using btree (lower(content)) where is_public = true;
create index idx_post_tags_gin on post using gin (tags);
create index idx_post_recent_public on post(created_at desc) where is_public = true;
create index idx_post_user_created on post (user_id, created_at desc);

-- test truy vấn sau khi có index
explain analyze select * from post where is_public = true and lower(content) like lower('%du lich%');
explain analyze select * from post where tags @> array['travel'];
explain analyze select * from post where is_public = true and created_at >= now() - interval '7 days';
explain analyze select * from post where user_id = 1 order by created_at desc;

-- thống kê index
select indexname, pg_size_pretty(pg_relation_size(indexrelid)) as size
from pg_stat_user_indexes where tablename = 'post';
-- phần 1: kiểm tra hiệu suất truy vấn trước khi tạo index

-- truy vấn 1: tìm sách theo tác giả
explain analyze select * from book where author ilike '%rowling%';

-- truy vấn 2: tìm sách theo thể loại
explain analyze select * from book where genre = 'fantasy';

-- phần 2: tạo các loại index theo yêu cầu

-- tạo b-tree index cho genre
create index idx_book_genre_btree on book using btree (genre);

-- tạo gin index cho title (full-text search)
create index idx_book_title_gin on book using gin (to_tsvector('english', title));

-- tạo gin index cho description (full-text search)  
create index idx_book_description_gin on book using gin (to_tsvector('english', description));

-- phần 3: kiểm tra hiệu suất sau khi tạo index

-- truy vấn 1: tìm sách theo tác giả sau khi có index
explain analyze select * from book where author ilike '%rowling%';

-- truy vấn 2: tìm sách theo thể loại sau khi có index
explain analyze select * from book where genre = 'fantasy';

-- truy vấn 3: full-text search với gin index
explain analyze select * from book where to_tsvector('english', title) @@ to_tsquery('english', 'harry');

-- phần 4: clustered index theo yêu cầu

-- cluster table theo genre
cluster book using idx_book_genre_btree;

-- kiểm tra hiệu suất sau khi cluster
explain analyze select * from book where genre = 'fantasy';
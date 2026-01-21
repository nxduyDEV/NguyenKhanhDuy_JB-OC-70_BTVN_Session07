
-- tạo bảng book
create table book (
    book_id serial primary key,
    title varchar(255),
    author varchar(100),
    genre varchar(50),
    price decimal(10,2),
    description text,
    created_at timestamp default current_timestamp
);

-- chèn dữ liệu mẫu (20 bản ghi)
insert into book (title, author, genre, price, description) values
('Harry Potter and the Philosopher Stone', 'J.K. Rowling', 'Fantasy', 15.99, 'Cuộc phiêu lưu kỳ diệu của cậu bé phù thủy Harry Potter tại trường Hogwarts'),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 12.50, 'Hành trình phiêu lưu của Bilbo Baggins cùng các người lùn'),
('1984', 'George Orwell', 'Dystopian', 14.25, 'Tiểu thuyết về xã hội độc tài và sự kiểm soát tâm trí'),
('Pride and Prejudice', 'Jane Austen', 'Romance', 11.75, 'Câu chuyện tình yêu giữa Elizabeth Bennet và Mr. Darcy'),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 13.80, 'Câu chuyện về công lý và phân biệt chủng tộc ở miền Nam nước Mỹ'),
('Harry Potter and the Chamber of Secrets', 'J.K. Rowling', 'Fantasy', 16.99, 'Harry Potter khám phá bí mật của phòng chứa bí mật'),
('The Lord of the Rings', 'J.R.R. Tolkien', 'Fantasy', 25.99, 'Cuộc chiến giữa thiện và ác ở Middle-earth'),
('Brave New World', 'Aldous Huxley', 'Dystopian', 13.50, 'Thế giới tương lai nơi hạnh phúc được kiểm soát bằng khoa học'),
('Jane Eyre', 'Charlotte Bronte', 'Romance', 12.30, 'Câu chuyện về cô gái mồ côi Jane Eyre và tình yêu của cô'),
('The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 14.60, 'Hành trình tìm kiếm bản thân của thiếu niên Holden Caulfield'),
('Harry Potter and the Prisoner of Azkaban', 'J.K. Rowling', 'Fantasy', 17.25, 'Harry Potter đối mặt với tù nhân nguy hiểm Sirius Black'),
('Animal Farm', 'George Orwell', 'Political Satire', 10.95, 'Câu chuyện ngụ ngôn về cuộc cách mạng của các con vật'),
('Wuthering Heights', 'Emily Bronte', 'Romance', 11.40, 'Tình yêu đầy đam mê và báo thù giữa Heathcliff và Catherine'),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 13.20, 'Giấc mơ Mỹ và sự sa đọa của xã hội thượng lưu'),
('Dune', 'Frank Herbert', 'Science Fiction', 18.75, 'Cuộc chiến cho gia vị quý giá trên hành tinh sa mạc Arrakis'),
('Fahrenheit 451', 'Ray Bradbury', 'Dystopian', 12.85, 'Thế giới tương lai nơi sách bị cấm và đốt cháy'),
('The Handmaids Tale', 'Margaret Atwood', 'Dystopian', 15.60, 'Xã hội totalitarian nơi phụ nữ bị kiểm soát hoàn toàn'),
('Foundation', 'Isaac Asimov', 'Science Fiction', 16.40, 'Khoa học tâm lý học dự đoán tương lai của đế chế thiên hà'),
('Neuromancer', 'William Gibson', 'Cyberpunk', 14.90, 'Thế giới cyberpunk với tin tặc và trí tuệ nhân tạo'),
('The Martian', 'Andy Weir', 'Science Fiction', 17.80, 'Cuộc sống sót thần kỳ của phi hành gia bị bỏ lại trên sao Hỏa');

-- hiển thị số lượng bản ghi đã chèn
select count(*) as total_books from book;

-- hiển thị một vài bản ghi mẫu
select book_id, title, author, genre, price from book limit 5;
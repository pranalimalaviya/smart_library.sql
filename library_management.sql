CREATE DATABASE smart_library;

USE smart_library;

-- 1.Authors Table

CREATE TABLE authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100)
);

-- 2. Books Table

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    author_id INT,
    category VARCHAR(50),
    isbn VARCHAR(20) UNIQUE,
    published_date DATE,
    price DECIMAL(10, 2),
    available_copies INT DEFAULT 0,

    FOREIGN KEY (author_id)
            REFERENCES authors(author_id)
);

-- 3. Members Table

CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(15),
    membership_date DATE
);

-- 4. Transactions Table

CREATE TABLE transactions (
    transactions_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    fine_amount DECIMAL (10, 2) DEFAULT 0.00,

    FOREIGN KEY (member_id)
        REFERENCES members(member_id),

    FOREIGN KEY (book_id) 
        REFERENCES books(book_id)
);

-- 1.Authors

INSERT INTO authors (name, email)
VALUES
('J.K. Rowling', 'jk@example.com'),
('George Orwell', 'orwell@example.com'),
('Stephen Hawking', 'hawking@example.com'),
('Yuval Noah Harari', 'yuval@example.com'),
('Robert Martin', 'martin@example.com'),
('Dan Brown', NULL),
('R.K. Narayan', 'narayan@example.com'),
('Isaac Asimov', NULL); 

-- 2.Books

INSERT INTO books 
(title, author_id, category, isbn, published_date, price, available_copies)
VALUES
('Harry Potter', 1, 'Fantasy', 'ISBN001', '1997-06-26', 450.00, 3),
('1984', 2, 'Fiction', 'ISBN002', '1949-06-08', 350.00, 2), 
('A Brief History of Time', 3, 'Science', 'ISBN003', '1988-04-01', 550.00, 4), 
('Sapiens', 4, 'History', 'ISBN004', '2011-01-01', 650.00, 2), 
('Clean Code', 5, 'Programming', 'ISBN005', '2008-08-01', 800.00, 5), 
('The Da Vinci Code', 6, 'Mystery', 'ISBN006', '2003-04-01', 600.00, 1), 
('Malgudi Days', 7, 'Fiction', 'ISBN007', '1943-01-01', 300.00, 0), 
('Foundation', 8, 'Science Fiction', 'ISBN008', '1951-06-01', 700.00, 3), 
('The Midnight Library', 1, 'Fiction', 'ISBN009', '2020-09-01', 500.00, 4), 
('Project Hail Mary', 3, 'Science', 'ISBN010', '2021-05-04', 750.00, 2);

-- 3.Members

INSERT INTO members
(name, email, phone_number, membership_date)
VALUES
('Rahul Sharma', 'rahul@example.com', '9876543210', '2021-05-10'), 
('Priya Patel', 'priya@example.com', '9876543211', '2023-02-15'), 
('Amit Shah', 'amit@example.com', '9876543212', '2020-08-20'), 
('Neha Mehta', NULL, '9876543213', '2024-01-12'), 
('Rohan Joshi', 'rohan@example.com', '9876543214', '2022-06-18'), 
('Karan Patel', 'karan@example.com', '9876543215', '2025-01-05');

-- 4.Transactions

INSERT INTO transactions
(member_id, book_id, borrow_date, return_date, fine_amount)
VALUES
(1, 1, '2025-11-10', '2025-11-20', 0.00), 
(1, 5, '2026-01-15', '2026-01-30', 20.00), 
(1, 3, '2026-03-05', '2026-03-15', 0.00), 
(1, 8, '2026-05-10', '2026-05-25', 10.00), 
(2, 10, '2026-02-10', '2026-02-20', 0.00), 
(2, 4, '2026-06-01', NULL, 0.00), 
(3, 2, '2024-05-10', '2024-05-25', 15.00), 
(3, 6, '2025-08-10', '2025-08-25', 10.00), 
(5, 7, '2025-12-01', '2025-12-20', 25.00), 
(6, 9, '2026-07-01', NULL, 0.00), 
(2, 5, '2026-07-15', NULL, 0.00);

-- Q=1. Implement CRUD Operations
-- 1.Insert new books, authors, and members
-- Insert Author

INSERT INTO authors (name, email)
VALUES
('Chetan Bhagat', 'chetan@example.com');

-- Insert Book
INSERT INTO books 
(title, author_id, category, isbn, published_date, price, available_copies)
VALUES
('Five Point Someone', 9, 'Fiction', 'ISBN011', '2004-01-01', 400.00, 3);

-- Insert Member
INSERT INTO members
(name, email, phone_number, membership_date)
VALUES
('Anjali Desai', 'anjali@example.com', '9876543220', CURDATE());


-- 2.Update book avaibility after borrowing
-- Update book

UPDATE books
SET available_copies = available_copies - 1
WHERE book_id = 4
AND available_copies > 0;

-- Update book avaibility after returning

UPDATE books
SET available_copies = available_copies + 1
WHERE book_id = 4;

-- 3.Delete members who haven't borrowed books in the last year
DELETE FROM members 
WHERE member_id NOT IN (
    SELECT DISTINCT member_id
    FROM transactions
    WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

-- 4.Retrive all books with available copies

SELECT *
FROM books 
WHERE available_copies > 0;

-- +------------------------------------------------------------------------------------------------------------------------+
-- | book_id | title                   | author_id | category        | isbn    | published_date | price  | available_copies |
-- +---------+-------------------------+-----------+-----------------+---------+----------------+--------+------------------+
-- |       1 | Harry Potter            |         1 | Fantasy         | ISBN001 | 1997-06-26     | 450.00 |                3 |
-- |       2 | 1984                    |         2 | Fiction         | ISBN002 | 1949-06-08     | 350.00 |                2 |
-- |       3 | A Brief History of Time |         3 | Science         | ISBN003 | 1988-04-01     | 550.00 |                4 |
-- |       4 | Sapiens                 |         4 | History         | ISBN004 | 2011-01-01     | 650.00 |                2 |
-- |       5 | Clean Code              |         5 | Programming     | ISBN005 | 2008-08-01     | 800.00 |                5 |
-- |       6 | The Da Vinci Code       |         6 | Mystery         | ISBN006 | 2003-04-01     | 600.00 |                1 |
-- |       8 | Foundation              |         8 | Science Fiction | ISBN008 | 1951-06-01     | 700.00 |                3 |
-- |       9 | The Midnight Library    |         1 | Fiction         | ISBN009 | 2020-09-01     | 500.00 |                4 |
-- |      10 | Project Hail Mary       |         3 | Science         | ISBN010 | 2021-05-04     | 750.00 |                2 |
-- |      11 | Five Point Someone      |         9 | Fiction         | ISBN011 | 2004-01-01     | 400.00 |                3 |
-- +---------+-------------------------+-----------+-----------------+---------+----------------+--------+------------------+


-- Q=2.Use SQL Clauses WHERE, HAVING, LIMIT
-- 1.Books published after 2015

SELECT *
FROM books
WHERE published_date > '2015-12-31';

-- +---------+----------------------+-----------+----------+---------+----------------+--------+------------------+
-- | book_id | title                | author_id | category | isbn    | published_date | price  | available_copies |
-- +---------+----------------------+-----------+----------+---------+----------------+--------+------------------+
-- |       9 | The Midnight Library |         1 | Fiction  | ISBN009 | 2020-09-01     | 500.00 |                4 |
-- |      10 | Project Hail Mary    |         3 | Science  | ISBN010 | 2021-05-04     | 750.00 |                2 |
-- +---------+----------------------+-----------+----------+---------+----------------+--------+------------------+

-- 2.Top 5 most expensive books

SELECT *
FROM books
ORDER BY price DESC
LIMIT 5;

-- +---------+-------------------+-----------+-----------------+---------+----------------+--------+------------------+
-- | book_id | title             | author_id | category        | isbn    | published_date | price  | available_copies |
-- +---------+-------------------+-----------+-----------------+---------+----------------+--------+------------------+
-- |       5 | Clean Code        |         5 | Programming     | ISBN005 | 2008-08-01     | 800.00 |                5 |
-- |      10 | Project Hail Mary |         3 | Science         | ISBN010 | 2021-05-04     | 750.00 |                2 |
-- |       8 | Foundation        |         8 | Science Fiction | ISBN008 | 1951-06-01     | 700.00 |                3 |
-- |       4 | Sapiens           |         4 | History         | ISBN004 | 2011-01-01     | 650.00 |                2 |
-- |       6 | The Da Vinci Code |         6 | Mystery         | ISBN006 | 2003-04-01     | 600.00 |                1 |
-- +---------+-------------------+-----------+-----------------+---------+----------------+--------+------------------+

-- 3.Member who joined before 2022

SELECT *
FROM members 
WHERE membership_date < '2022-01-01';

-- +-----------+--------------+-------------------+--------------+-----------------+
-- | member_id | name         | email             | phone_number | membership_date |
-- +-----------+--------------+-------------------+--------------+-----------------+
-- |         1 | Rahul Sharma | rahul@example.com | 9876543210   | 2021-05-10      |
-- |         3 | Amit Shah    | amit@example.com  | 9876543212   | 2020-08-20      |
-- +-----------+--------------+-------------------+--------------+-----------------+


-- Q=3.Apply SQL Operators-AND, OR, NOT
-- 1.Science books AND price less than 500

SELECT *
FROM books
WHERE category = 'Science'
AND price < 500;

-- 2.Books that are NOT available for borrowing

SELECT *
FROM books
WHERE NOT available_copies > 0;

-- +---------+--------------+-----------+----------+---------+----------------+--------+------------------+
-- | book_id | title        | author_id | category | isbn    | published_date | price  | available_copies |
-- +---------+--------------+-----------+----------+---------+----------------+--------+------------------+
-- |       7 | Malgudi Days |         7 | Fiction  | ISBN007 | 1943-01-01     | 300.00 |                0 |
-- +---------+--------------+-----------+----------+---------+----------------+--------+------------------+

-- 3.Members who join after 2020 OR borrowed more than 3 books
SELECT 
    m.member_id, 
    m.name, 
    m.membership_date, 
    COUNT(t.book_id) AS borrowed_books 
FROM members m 
LEFT JOIN transactions t 
    ON m.member_id = t.member_id 
GROUP BY 
    m.member_id, 
    m.name, 
    m.membership_date 
HAVING 
    m.membership_date > '2020-12-31' 
    OR COUNT(t.book_id) > 3;

-- +-----------+--------------+-----------------+----------------+
-- | member_id | name         | membership_date | borrowed_books |
-- +-----------+--------------+-----------------+----------------+
-- |         1 | Rahul Sharma | 2021-05-10      |              4 |
-- |         2 | Priya Patel  | 2023-02-15      |              3 |
-- |         4 | Neha Mehta   | 2024-01-12      |              0 |
-- |         5 | Rohan Joshi  | 2022-06-18      |              1 |
-- |         6 | Karan Patel  | 2025-01-05      |              1 |
-- |         7 | Anjali Desai | 2026-09-11      |              0 |
-- +-----------+--------------+-----------------+----------------+


-- Q=4.Sorting & Grouping Data 
-- 1.List books alphabetically by title

SELECT *
FROM books 
ORDER BY title ASC;

-- 2. Number of books borrowed by each member
-- Display the number of books borrowed by each member

SELECT
    m.member_id,
    m.name,
    COUNT(t.book_id) AS books_borrowed
FROM members m
LEFT JOIN transactions t
    ON m.member_id = t.member_id
GROUP BY
    m.member_id,
    m.name;

-- +-----------+--------------+----------------+
-- | member_id | name         | books_borrowed |
-- +-----------+--------------+----------------+
-- |         1 | Rahul Sharma |              4 |
-- |         2 | Priya Patel  |              3 |
-- |         3 | Amit Shah    |              2 |
-- |         4 | Neha Mehta   |              0 |
-- |         5 | Rohan Joshi  |              1 |
-- |         6 | Karan Patel  |              1 |
-- |         7 | Anjali Desai |              0 |
-- +-----------+--------------+----------------+

-- 3. Group books by category and show total count

SELECT 
    category,
    COUNT(*) AS total_books
FROM books 
GROUP BY category;

-- +-----------------+-------------+
-- | category        | total_books |
-- +-----------------+-------------+
-- | Fantasy         |           1 |
-- | Fiction         |           4 |
-- | Science         |           2 |
-- | History         |           1 |
-- | Programming     |           1 |
-- | Mystery         |           1 |
-- | Science Fiction |           1 |
-- +-----------------+-------------+


-- Q5. Aggregate Functions
-- 1. Total number of books in each category

SELECT
    category,
    COUNT(*) AS total_books
FROM books
GROUP BY category;

-- +-----------------+-------------+
-- | category        | total_books |
-- +-----------------+-------------+
-- | Fantasy         |           1 |
-- | Fiction         |           4 |
-- | Science         |           2 |
-- | History         |           1 |
-- | Programming     |           1 |
-- | Mystery         |           1 |
-- | Science Fiction |           1 |
-- +-----------------+-------------+

-- 2. Average price of books

SELECT
    AVG(price) AS total_books
FROM books  
GROUP BY category;

-- +-------------+
-- | total_books |
-- +-------------+
-- |  450.000000 |
-- |  387.500000 |
-- |  650.000000 |
-- |  650.000000 |
-- |  800.000000 |
-- |  600.000000 |
-- |  700.000000 |
-- +-------------+

-- 3. Most borrowed book
SELECT
    b.book_id,
    b.title,
    COUNT(t.book_id) AS times_borrowed
FROM books b
JOIN transactions t
    ON b.book_id = t.book_id
GROUP BY
    b.book_id,
    b.title
ORDER BY times_borrowed DESC
LIMIT 1;

-- +---------+------------+----------------+
-- | book_id | title      | times_borrowed |
-- +---------+------------+----------------+
-- |       5 | Clean Code |              2 |
-- +---------+------------+----------------+

-- 4. Total fines collected

SELECT 
    SUM(fine_amount) AS total_fines 
FROM transactions;

-- +-------------+
-- | total_fines |
-- +-------------+
-- |       80.00 |
-- +-------------+

-- Q6. Primary & Foreign Key Relationships
-- 1. Ensure books are linked to authors
SELECT
    b.book_id,
    b.title,
    b.author_id,
    a.author_id,
    a.name AS author_name
FROM books b
INNER JOIN authors a
    ON b.author_id = a.author_id;

-- +---------+-------------------------+-----------+-----------+-------------------+
-- | book_id | title                   | author_id | author_id | author_name       |
-- +---------+-------------------------+-----------+-----------+-------------------+
-- |       1 | Harry Potter            |         1 |         1 | J.K. Rowling      |
-- |       9 | The Midnight Library    |         1 |         1 | J.K. Rowling      |
-- |       2 | 1984                    |         2 |         2 | George Orwell     |
-- |       3 | A Brief History of Time |         3 |         3 | Stephen Hawking   |
-- |      10 | Project Hail Mary       |         3 |         3 | Stephen Hawking   |
-- |       4 | Sapiens                 |         4 |         4 | Yuval Noah Harari |
-- |       5 | Clean Code              |         5 |         5 | Robert Martin     |
-- |       6 | The Da Vinci Code       |         6 |         6 | Dan Brown         |
-- |       7 | Malgudi Days            |         7 |         7 | R.K. Narayan      |
-- |       8 | Foundation              |         8 |         8 | Isaac Asimov      |
-- |      11 | Five Point Someone      |         9 |         9 | Chetan Bhagat     |
-- +---------+-------------------------+-----------+-----------+-------------------+


-- 2. Relationship between members and transactions
SELECT
    m.member_id,
    m.name,
    t.book_id,
    t.borrow_date,
    t.return_date
FROM members m
INNER JOIN transactions t
    ON m.member_id = t.member_id;

-- +-----------+--------------+---------+-------------+-------------+
-- | member_id | name         | book_id | borrow_date | return_date |
-- +-----------+--------------+---------+-------------+-------------+
-- |         1 | Rahul Sharma |       1 | 2025-11-10  | 2025-11-20  |
-- |         1 | Rahul Sharma |       5 | 2026-01-15  | 2026-01-30  |
-- |         1 | Rahul Sharma |       3 | 2026-03-05  | 2026-03-15  |
-- |         1 | Rahul Sharma |       8 | 2026-05-10  | 2026-05-25  |
-- |         2 | Priya Patel  |      10 | 2026-02-10  | 2026-02-20  |
-- |         2 | Priya Patel  |       4 | 2026-06-01  | NULL        |
-- |         2 | Priya Patel  |       5 | 2026-07-15  | NULL        |
-- |         3 | Amit Shah    |       2 | 2024-05-10  | 2024-05-25  |
-- |         3 | Amit Shah    |       6 | 2025-08-10  | 2025-08-25  |
-- |         5 | Rohan Joshi  |       7 | 2025-12-01  | 2025-12-20  |
-- |         6 | Karan Patel  |       9 | 2026-07-01  | NULL        |
-- +-----------+--------------+---------+-------------+-------------+


-- Q7. Implement Joins
-- 1. INNER JOIN — Books with author names
SELECT
    b.book_id,
    b.title,
    a.name AS author_name
FROM books b
INNER JOIN authors a
    ON b.author_id = a.author_id;

-- +---------+-------------------------+-------------------+
-- | book_id | title                   | author_name       |
-- +---------+-------------------------+-------------------+
-- |       1 | Harry Potter            | J.K. Rowling      |
-- |       9 | The Midnight Library    | J.K. Rowling      |
-- |       2 | 1984                    | George Orwell     |
-- |       3 | A Brief History of Time | Stephen Hawking   |
-- |      10 | Project Hail Mary       | Stephen Hawking   |
-- |       4 | Sapiens                 | Yuval Noah Harari |
-- |       5 | Clean Code              | Robert Martin     |
-- |       6 | The Da Vinci Code       | Dan Brown         |
-- |       7 | Malgudi Days            | R.K. Narayan      |
-- |       8 | Foundation              | Isaac Asimov      |
-- |      11 | Five Point Someone      | Chetan Bhagat     |
-- +---------+-------------------------+-------------------+

-- 2. LEFT JOIN — Members who have borrowed books
SELECT
    m.member_id,
    m.name,
    t.book_id,
    t.borrow_date
FROM members m
LEFT JOIN transactions t
    ON m.member_id = t.member_id;

-- +-----------+--------------+---------+-------------+
-- | member_id | name         | book_id | borrow_date |
-- +-----------+--------------+---------+-------------+
-- |         1 | Rahul Sharma |       1 | 2025-11-10  |
-- |         1 | Rahul Sharma |       5 | 2026-01-15  |
-- |         1 | Rahul Sharma |       3 | 2026-03-05  |
-- |         1 | Rahul Sharma |       8 | 2026-05-10  |
-- |         2 | Priya Patel  |      10 | 2026-02-10  |
-- |         2 | Priya Patel  |       4 | 2026-06-01  |
-- |         2 | Priya Patel  |       5 | 2026-07-15  |
-- |         3 | Amit Shah    |       2 | 2024-05-10  |
-- |         3 | Amit Shah    |       6 | 2025-08-10  |
-- |         4 | Neha Mehta   |    NULL | NULL        |
-- |         5 | Rohan Joshi  |       7 | 2025-12-01  |
-- |         6 | Karan Patel  |       9 | 2026-07-01  |
-- |         7 | Anjali Desai |    NULL | NULL        |
-- +-----------+--------------+---------+-------------+

-- 3. RIGHT JOIN — Books that haven't been borrowed
-- Find books that haven't been borrowed

SELECT
    b.book_id,
    b.title
FROM transactions t
RIGHT JOIN books b
    ON t.book_id = b.book_id
WHERE t.book_id IS NULL;

-- +---------+--------------------+
-- | book_id | title              |
-- +---------+--------------------+
-- |      11 | Five Point Someone |
-- +---------+--------------------+

-- 4. FULL OUTER JOIN 
-- Members who have never borrowed a book

SELECT 
    m.member_id, 
    m.name, 
    t.book_id 
FROM members m 
LEFT JOIN transactions t 
    ON m.member_id = t.member_id 

UNION 

SELECT 
    m.member_id, 
    m.name, 
    t.book_id 
FROM members m 
RIGHT JOIN transactions t 
    ON m.member_id = t.member_id;

-- +-----------+--------------+---------+
-- | member_id | name         | book_id |
-- +-----------+--------------+---------+
-- |         1 | Rahul Sharma |       1 |
-- |         1 | Rahul Sharma |       5 |
-- |         1 | Rahul Sharma |       3 |
-- |         1 | Rahul Sharma |       8 |
-- |         2 | Priya Patel  |      10 |
-- |         2 | Priya Patel  |       4 |
-- |         2 | Priya Patel  |       5 |
-- |         3 | Amit Shah    |       2 |
-- |         3 | Amit Shah    |       6 |
-- |         4 | Neha Mehta   |    NULL |
-- |         5 | Rohan Joshi  |       7 |
-- |         6 | Karan Patel  |       9 |
-- |         7 | Anjali Desai |    NULL |
-- +-----------+--------------+---------+


-- Q8. Use Subqueries
-- 1. Books borrowed by members registered after 2022
SELECT *
FROM books
WHERE book_id IN (
    SELECT book_id
    FROM transactions
    WHERE member_id IN (
        SELECT member_id
        FROM members
        WHERE membership_date > '2022-12-31'
    )
);

-- +---------+----------------------+-----------+-------------+---------+----------------+--------+------------------+
-- | book_id | title                | author_id | category    | isbn    | published_date | price  | available_copies |
-- +---------+----------------------+-----------+-------------+---------+----------------+--------+------------------+
-- |      10 | Project Hail Mary    |         3 | Science     | ISBN010 | 2021-05-04     | 750.00 |                2 |
-- |       4 | Sapiens              |         4 | History     | ISBN004 | 2011-01-01     | 650.00 |                2 |
-- |       5 | Clean Code           |         5 | Programming | ISBN005 | 2008-08-01     | 800.00 |                5 |
-- |       9 | The Midnight Library |         1 | Fiction     | ISBN009 | 2020-09-01     | 500.00 |                4 |
-- +---------+----------------------+-----------+-------------+---------+----------------+--------+------------------+

-- 2. Identify the most borrowed book using a subquery
SELECT
    book_id,
    title
FROM books
WHERE book_id = (
    SELECT book_id
    FROM transactions
    GROUP BY book_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- +---------+------------+
-- | book_id | title      |
-- +---------+------------+
-- |       5 | Clean Code |
-- +---------+------------+
-- 3. Members who have never borrowed a book
SELECT *
FROM members
WHERE member_id NOT IN (
    SELECT DISTINCT member_id
    FROM transactions
);

-- +-----------+--------------+--------------------+--------------+-----------------+
-- | member_id | name         | email              | phone_number | membership_date |
-- +-----------+--------------+--------------------+--------------+-----------------+
-- |         4 | Neha Mehta   | NULL               | 9876543213   | 2024-01-12      |
-- |         7 | Anjali Desai | anjali@example.com | 9876543220   | 2026-09-11      |
-- +-----------+--------------+--------------------+--------------+-----------------+

-- Q9. Date & Time Functions
-- 1. Extract year from published_date
SELECT
    title,
    published_date,
    YEAR(published_date) AS publication_year
FROM books;

-- +-------------------------+----------------+------------------+
-- | title                   | published_date | publication_year |
-- +-------------------------+----------------+------------------+
-- | Harry Potter            | 1997-06-26     |             1997 |
-- | 1984                    | 1949-06-08     |             1949 |
-- | A Brief History of Time | 1988-04-01     |             1988 |
-- | Sapiens                 | 2011-01-01     |             2011 |
-- | Clean Code              | 2008-08-01     |             2008 |
-- | The Da Vinci Code       | 2003-04-01     |             2003 |
-- | Malgudi Days            | 1943-01-01     |             1943 |
-- | Foundation              | 1951-06-01     |             1951 |
-- | The Midnight Library    | 2020-09-01     |             2020 |
-- | Project Hail Mary       | 2021-05-04     |             2021 |
-- | Five Point Someone      | 2004-01-01     |             2004 |
-- -- +-------------------------+----------------+------------------+
-- Count books by publication year
SELECT
    YEAR(published_date) AS publication_year,
    COUNT(*) AS total_books
FROM books
GROUP BY YEAR(published_date)
ORDER BY publication_year;

-- +------------------+-------------+
-- | publication_year | total_books |
-- +------------------+-------------+
-- |             1943 |           1 |
-- |             1949 |           1 |
-- |             1951 |           1 |
-- |             1988 |           1 |
-- |             1997 |           1 |
-- |             2003 |           1 |
-- |             2004 |           1 |
-- |             2008 |           1 |
-- |             2011 |           1 |
-- |             2020 |           1 |
-- |             2021 |           1 |
-- +------------------+-------------+

-- 2. Difference between borrow and return dates
SELECT
    book_id,
    borrow_date,
    return_date,
    DATEDIFF(return_date, borrow_date) AS borrowing_days
FROM transactions
WHERE return_date IS NOT NULL;

-- +---------+-------------+-------------+----------------+
-- | book_id | borrow_date | return_date | borrowing_days |
-- +---------+-------------+-------------+----------------+
-- |       1 | 2025-11-10  | 2025-11-20  |             10 |
-- |       5 | 2026-01-15  | 2026-01-30  |             15 |
-- |       3 | 2026-03-05  | 2026-03-15  |             10 |
-- |       8 | 2026-05-10  | 2026-05-25  |             15 |
-- |      10 | 2026-02-10  | 2026-02-20  |             10 |
-- |       2 | 2024-05-10  | 2024-05-25  |             15 |
-- |       6 | 2025-08-10  | 2025-08-25  |             15 |
-- |       7 | 2025-12-01  | 2025-12-20  |             19 |
-- +---------+-------------+-------------+----------------+

-- Calculate late return fine

SELECT 
    book_id, 
    borrow_date, 
    return_date,
 
    DATEDIFF(return_date, borrow_date) AS total_days, 

    CASE 
        WHEN DATEDIFF(return_date, borrow_date) > 14 
        THEN (DATEDIFF(return_date, borrow_date) - 14) * 5 
        ELSE 0 
    END AS calculated_fine 
FROM transactions 
WHERE return_date IS NOT NULL;

-- +---------+-------------+-------------+------------+-----------------+
-- | book_id | borrow_date | return_date | total_days | calculated_fine |
-- +---------+-------------+-------------+------------+-----------------+
-- |       1 | 2025-11-10  | 2025-11-20  |         10 |               0 |
-- |       5 | 2026-01-15  | 2026-01-30  |         15 |               5 |
-- |       3 | 2026-03-05  | 2026-03-15  |         10 |               0 |
-- |       8 | 2026-05-10  | 2026-05-25  |         15 |               5 |
-- |      10 | 2026-02-10  | 2026-02-20  |         10 |               0 |
-- |       2 | 2024-05-10  | 2024-05-25  |         15 |               5 |
-- |       6 | 2025-08-10  | 2025-08-25  |         15 |               5 |
-- |       7 | 2025-12-01  | 2025-12-20  |         19 |              25 |
-- +---------+-------------+-------------+------------+-----------------+

-- 3. Format borrow_date as DD-MM-YYYY
SELECT
    book_id,
    DATE_FORMAT(borrow_date, '%d-%m-%Y') AS formatted_borrow_date
FROM transactions;

-- +---------+-----------------------+
-- | book_id | formatted_borrow_date |
-- +---------+-----------------------+
-- |       1 | 10-11-2025            |
-- |       5 | 15-01-2026            |
-- |       3 | 05-03-2026            |
-- |       8 | 10-05-2026            |
-- |      10 | 10-02-2026            |
-- |       4 | 01-06-2026            |
-- |       2 | 10-05-2024            |
-- |       6 | 10-08-2025            |
-- |       7 | 01-12-2025            |
-- |       9 | 01-07-2026            |
-- |       5 | 15-07-2026            |
-- +---------+-----------------------+

-- Q10. String Manipulation Functions
-- 1. Convert all book titles to uppercase
SELECT
    book_id,
    UPPER(title) AS uppercase_title
FROM books;

-- +---------+-------------------------+
-- | book_id | uppercase_title         |
-- +---------+-------------------------+
-- |       1 | HARRY POTTER            |
-- |       2 | 1984                    |
-- |       3 | A BRIEF HISTORY OF TIME |
-- |       4 | SAPIENS                 |
-- |       5 | CLEAN CODE              |
-- |       6 | THE DA VINCI CODE       |
-- |       7 | MALGUDI DAYS            |
-- |       8 | FOUNDATION              |
-- |       9 | THE MIDNIGHT LIBRARY    |
-- |      10 | PROJECT HAIL MARY       |
-- |      11 | FIVE POINT SOMEONE      |
-- +---------+-------------------------+

-- 2. Trim whitespace from author names
SELECT
    author_id,
    TRIM(name) AS trimmed_name
FROM authors;

-- +-----------+-------------------+
-- | author_id | trimmed_name      |
-- +-----------+-------------------+
-- |         1 | J.K. Rowling      |
-- |         2 | George Orwell     |
-- |         3 | Stephen Hawking   |
-- |         4 | Yuval Noah Harari |
-- |         5 | Robert Martin     |
-- |         6 | Dan Brown         |
-- |         7 | R.K. Narayan      |
-- |         8 | Isaac Asimov      |
-- |         9 | Chetan Bhagat     |
-- +-----------+-------------------+
-- 3. Replace missing email values with "Not Provided"
SELECT
    author_id,
    name,
    COALESCE(email, 'Not Provided') AS email
FROM authors;

-- +-----------+-------------------+---------------------+
-- | author_id | name              | email               |
-- +-----------+-------------------+---------------------+
-- |         1 | J.K. Rowling      | jk@example.com      |
-- |         2 | George Orwell     | orwell@example.com  |
-- |         3 | Stephen Hawking   | hawking@example.com |
-- |         4 | Yuval Noah Harari | yuval@example.com   |
-- |         5 | Robert Martin     | martin@example.com  |
-- |         6 | Dan Brown         | Not Provided        |
-- |         7 | R.K. Narayan      | narayan@example.com |
-- |         8 | Isaac Asimov      | Not Provided        |
-- |         9 | Chetan Bhagat     | chetan@example.com  |
-- +-----------+-------------------+---------------------+

-- For members:

SELECT
    member_id,
    name,
    COALESCE(email, 'Not Provided') AS email
FROM members;

-- +-----------+--------------+--------------------+
-- | member_id | name         | email              |
-- +-----------+--------------+--------------------+
-- |         1 | Rahul Sharma | rahul@example.com  |
-- |         2 | Priya Patel  | priya@example.com  |
-- |         3 | Amit Shah    | amit@example.com   |
-- |         4 | Neha Mehta   | Not Provided       |
-- |         5 | Rohan Joshi  | rohan@example.com  |
-- |         6 | Karan Patel  | karan@example.com  |
-- |         7 | Anjali Desai | anjali@example.com |
-- +-----------+--------------+--------------------+

-- Q11. Window Functions
-- 1. Rank books based on number of times borrowed

SELECT 
    book_id, 
    title, 
    total_borrowed, 
    
    RANK() OVER ( 
        ORDER BY total_borrowed DESC 
    ) AS borrowing_rank 
FROM ( 
    SELECT 
        b.book_id, 
        b.title, 
        COUNT(t.book_id) AS total_borrowed 

    FROM books b 
    LEFT JOIN transactions t 
        ON b.book_id = t.book_id
    
    GROUP BY 
        b.book_id, 
        b.title 
    ) AS book_data;

-- +---------+-------------------------+----------------+----------------+
-- | book_id | title                   | total_borrowed | borrowing_rank |
-- +---------+-------------------------+----------------+----------------+
-- |       5 | Clean Code              |              2 |              1 |
-- |       1 | Harry Potter            |              1 |              2 |
-- |       2 | 1984                    |              1 |              2 |
-- |       3 | A Brief History of Time |              1 |              2 |
-- |       4 | Sapiens                 |              1 |              2 |
-- |       6 | The Da Vinci Code       |              1 |              2 |
-- |       7 | Malgudi Days            |              1 |              2 |
-- |       8 | Foundation              |              1 |              2 |
-- |       9 | The Midnight Library    |              1 |              2 |
-- |      10 | Project Hail Mary       |              1 |              2 |
-- |      11 | Five Point Someone      |              0 |             11 |
-- +---------+-------------------------+----------------+----------------+

-- 2. Cumulative number of books borrowed per member
SELECT
    member_id,
    book_id,
    borrow_date,

    COUNT(*) OVER (
        PARTITION BY member_id
        ORDER BY borrow_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_books_borrowed

FROM transactions

ORDER BY
    member_id,
    borrow_date;

-- +-----------+---------+-------------+---------------------------+
-- | member_id | book_id | borrow_date | cumulative_books_borrowed |
-- +-----------+---------+-------------+---------------------------+
-- |         1 |       1 | 2025-11-10  |                         1 |
-- |         1 |       5 | 2026-01-15  |                         2 |
-- |         1 |       3 | 2026-03-05  |                         3 |
-- |         1 |       8 | 2026-05-10  |                         4 |
-- |         2 |      10 | 2026-02-10  |                         1 |
-- |         2 |       4 | 2026-06-01  |                         2 |
-- |         2 |       5 | 2026-07-15  |                         3 |
-- |         3 |       2 | 2024-05-10  |                         1 |
-- |         3 |       6 | 2025-08-10  |                         2 |
-- |         5 |       7 | 2025-12-01  |                         1 |
-- |         6 |       9 | 2026-07-01  |                         1 |
-- +-----------+---------+-------------+---------------------------+

-- 3. Moving average of books borrowed in the last 3 months

WITH monthly_borrowing AS (
    
    SELECT
        DATE_FORMAT(borrow_date, '%Y-%m-01') AS borrow_month,
        COUNT(*) AS books_borrowed

    FROM transactions

    GROUP BY
        DATE_FORMAT(borrow_date, '%Y-%m-01')
)

SELECT
    borrow_month,
    books_borrowed,

    AVG(books_borrowed) OVER (
        ORDER BY borrow_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS three_month_moving_average

FROM monthly_borrowing

ORDER BY borrow_month;

-- +--------------+----------------+----------------------------+
-- | borrow_month | books_borrowed | three_month_moving_average |
-- +--------------+----------------+----------------------------+
-- | 2024-05-01   |              2 |                     2.0000 |
-- | 2025-08-01   |              2 |                     2.0000 |
-- | 2025-11-01   |              2 |                     2.0000 |
-- | 2025-12-01   |              2 |                     2.0000 |
-- | 2026-01-01   |              2 |                     2.0000 |
-- | 2026-02-01   |              2 |                     2.0000 |
-- | 2026-03-01   |              2 |                     2.0000 |
-- | 2026-05-01   |              2 |                     2.0000 |
-- | 2026-06-01   |              2 |                     2.0000 |
-- | 2026-07-01   |              4 |                     2.6667 |
-- +--------------+----------------+----------------------------+

-- Q12. CASE Expressions
-- 1. Membership Status

SELECT
    m.member_id,
    m.name,

    CASE 
        WHEN MAX(t.borrow_date) >=
            DATE_SUB(CURDATE(),INTERVAL 6 MONTH)    
        THEN 'Active'  
        ELSE 'Inactive'  
    END AS Membership_Status

    FROM members m    

    LEFT JOIN transactions t   
        ON m.member_id = t.member_id

    GROUP BY 
        m.member_id,
        m.name;

-- +-----------+--------------+-------------------+
-- | member_id | name         | Membership_Status |
-- +-----------+--------------+-------------------+
-- |         1 | Rahul Sharma | Active            |
-- |         2 | Priya Patel  | Active            |
-- |         3 | Amit Shah    | Inactive          |
-- |         4 | Neha Mehta   | Inactive          |
-- |         5 | Rohan Joshi  | Inactive          |
-- |         6 | Karan Patel  | Active            |
-- |         7 | Anjali Desai | Inactive          |
-- |         8 | Rahul Sharma | Inactive          |
-- |         9 | Priya Patel  | Inactive          |
-- |        10 | Amit Shah    | Inactive          |
-- |        11 | Neha Mehta   | Inactive          |
-- |        12 | Rohan Joshi  | Inactive          |
-- |        13 | Karan Patel  | Inactive          |
-- |        14 | Anjali Desai | Inactive          |
-- +-----------+--------------+-------------------+

-- 2. Categorize books


SELECT
    book_id,
    title,
    published_date,

    CASE
        WHEN published_date > '2020-12-31'
            THEN 'New Arrival'

        WHEN published_date < '2000-01-01'
            THEN 'Classic'

        ELSE 'Regular'
    END AS book_type

FROM books;

-- +---------+-------------------------+----------------+-------------+
-- | book_id | title                   | published_date | book_type   |
-- +---------+-------------------------+----------------+-------------+
-- |       1 | Harry Potter            | 1997-06-26     | Classic     |
-- |       2 | 1984                    | 1949-06-08     | Classic     |
-- |       3 | A Brief History of Time | 1988-04-01     | Classic     |
-- |       4 | Sapiens                 | 2011-01-01     | Regular     |
-- |       5 | Clean Code              | 2008-08-01     | Regular     |
-- |       6 | The Da Vinci Code       | 2003-04-01     | Regular     |
-- |       7 | Malgudi Days            | 1943-01-01     | Classic     |
-- |       8 | Foundation              | 1951-06-01     | Classic     |
-- |       9 | The Midnight Library    | 2020-09-01     | Regular     |
-- |      10 | Project Hail Mary       | 2021-05-04     | New Arrival |
-- |      11 | Five Point Someone      | 2004-01-01     | Regular     |
-- +---------+-------------------------+----------------+-------------+


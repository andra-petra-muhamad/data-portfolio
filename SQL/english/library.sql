/* 
A library needs a simple system to record book data and loan transactions.  
The system should be able to:  
1. Store a catalog of available books.  
2. Record who borrows the books, the number of books borrowed, and the borrow/return dates.  
3. Maintain data consistency, e.g., only books available in the catalog can be borrowed.  

To achieve this, two main tables are created: `books` and `loans`.  
The relationship between tables is managed using a foreign key to ensure data integrity.  
*/

/* Create Database and Books Table */
-- Create database
CREATE DATABASE library;

-- Create books table
CREATE TABLE library.books (
    book_id VARCHAR(255) NOT NULL PRIMARY KEY,
    book_title VARCHAR(255) NOT NULL,
    author_name VARCHAR(255) NULL,
    stock_quantity INTEGER NULL
);

-- Check if table is created
SELECT * FROM library.books;

/* Add Location Column to Books Table */
ALTER TABLE library.books
ADD location VARCHAR(255);

-- Check result after modification
SELECT * FROM library.books;

/* Create Loans Table */
CREATE TABLE library.loans (
    loan_id VARCHAR(255) NOT NULL PRIMARY KEY,
    borrower_name VARCHAR(255) NOT NULL,
    book_id VARCHAR(255) NOT NULL,
    quantity_borrowed INTEGER NOT NULL,
    borrow_date DATE NOT NULL,
    expected_return_date DATE NULL,
    actual_return_date DATE NULL,
    FOREIGN KEY (book_id) REFERENCES library.books(book_id)
);

-- Check if table is created
SELECT * FROM library.loans;

-- Check table structure
EXPLAIN library.loans;

/* Insert Data into Books Table */
INSERT INTO library.books (book_id, book_title, author_name, stock_quantity, location)
VALUES
    ('B001', 'Laskar Pelangi', 'Andrea Hirata', 5, 'Shelf A1'),
    ('B002', 'Bumi Manusia', 'Pramoedya Ananta Toer', 3, 'Shelf A2'),
    ('B003', 'Philosophy of Coffee', 'Dewi Lestari', 4, 'Shelf A3'),
    ('B004', 'The Land of Five Towers', 'Ahmad Fuadi', 2, 'Shelf A1'),
    ('B005', 'The Dreamer', 'Andrea Hirata', 6, 'Shelf A2')
    ;

/* Insert Data into Loans Table */
INSERT INTO library.loans 
(loan_id, borrower_name, book_id, quantity_borrowed, borrow_date, expected_return_date, actual_return_date)
VALUES
    ('P001', 'Rizka', 'B001', 1, '2023-01-10', '2023-01-17', '2023-01-16'),
    ('P002', 'Nandang', 'B002', 1, '2023-02-01', '2023-02-08', NULL),
    ('P003', 'Siti', 'B003', 2, '2023-02-15', '2023-02-22', '2023-02-20'),
    ('P004', 'Budi', 'B001', 1, '2023-03-05', '2023-03-12', NULL),
    ('P005', 'Adi', 'B005', 1, '2023-04-01', '2023-04-08', '2023-04-07')
    ;

/* Questions & Queries */
-- 1. Display all books available in the library
SELECT * FROM library.books;

-- 2. Display all loan records where books have not yet been returned
SELECT loan_id, borrower_name, book_id, borrow_date, expected_return_date
FROM library.loans
WHERE actual_return_date IS NULL;

-- 3. Who has borrowed the book "Laskar Pelangi"?
SELECT l.borrower_name, b.book_title
FROM library.loans l
JOIN library.books b ON l.book_id = b.book_id
WHERE b.book_title = 'Laskar Pelangi';

-- 4. Show the total stock of books per author
SELECT author_name, SUM(stock_quantity) AS total_stock
FROM library.books
GROUP BY author_name;

-- 5. Show borrowers who returned books late (actual_return_date > expected_return_date)
SELECT borrower_name, book_id, expected_return_date, actual_return_date
FROM library.loans
WHERE actual_return_date > expected_return_date;

-- 6. Which book is borrowed the most?
SELECT b.book_title, COUNT(*) AS times_borrowed
FROM library.loans l
JOIN library.books b ON l.book_id = b.book_id
GROUP BY b.book_title
ORDER BY times_borrowed DESC
LIMIT 1;

-- Check all loan records
SELECT * FROM library.loans;

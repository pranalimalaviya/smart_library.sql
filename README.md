# Smart Library Management System

## Project Overview

The **Smart Library Management System** is a MySQL-based database project designed to manage the core operations of a library.

The system stores and manages information about:

* Books
* Authors
* Library Members
* Borrowing and Returning Transactions

The project demonstrates a wide range of **SQL concepts**, from basic CRUD operations to advanced queries involving 
joins, subqueries, aggregate functions, window functions, date manipulation, string functions, and CASE expressions.

## Objectives

The main objectives of this project are to:

* Create and manage a relational library database.
* Store information about authors, books, members, and transactions.
* Establish relationships between different tables using Primary Keys and Foreign Keys.
* Perform CRUD operations.
* Retrieve and filter library data.
* Analyze borrowing activity using aggregate functions.
* Use different types of SQL JOINs.
* Implement subqueries and `NOT EXISTS`.
* Perform date and string manipulation.
* Use window functions for advanced analysis.
* Generate useful library and member activity reports.
* Simulate real-world book borrowing and returning operations.

## Database Structure

### Database Name

smart_library

### Tables

The project contains four main tables:

| Table          | Description                            |
| -------------- | -------------------------------------- |
| `authors`      | Stores author information              |
| `books`        | Stores book details                    |
| `members`      | Stores library member information      |
| `transactions` | Stores borrowing and returning records |


### Relationships Explained

* One **Author** can have many **Books**.
* One **Book** can appear in many **Transactions**.
* One **Member** can have many **Transactions**.
* `books.author_id` references `authors.author_id`.
* `transactions.member_id` references `members.member_id`.
* `transactions.book_id` references `books.book_id`.

## Table Structure

### 1. Authors

Stores information about book authors.

author_id
name
email

The `author_id` column is the **Primary Key**.

### 2. Books

Stores information about books available in the library.

book_id
title
author_id
category
isbn
published_date
price
available_copies

Important constraints:

* `book_id` → Primary Key
* `author_id` → Foreign Key
* `isbn` → Unique
* `title` → Not Null

### 3. Members

Stores library member information.

member_id
name
email
phone_number
membership_date

The `member_id` column is the **Primary Key**.

### 4. Transactions

Stores book borrowing and returning information.

transaction_id
member_id
book_id
borrow_date
return_date
fine_amount

Important constraints:

* `transaction_id` → Primary Key
* `member_id` → Foreign Key
* `book_id` → Foreign Key
* `return_date` can be `NULL` when a book has not been returned.

## Sample Data

The project contains sample data for:

* 8 authors
* 10 books
* 6 members
* 11 transactions

The sample books include different categories such as:

* Fantasy
* Fiction
* Science
* History
* Programming
* Mystery
* Science Fiction


## Features Implemented

### CRUD Operations

The project demonstrates all four CRUD operations:

#### CREATE
INSERT INTO authors (name, email)
VALUES ('Chetan Bhagat', 'chetan@example.com');

#### READ
SELECT *
FROM books;

#### UPDATE
UPDATE books
SET price = 850.00
WHERE book_id = 5;

#### DELETE
DELETE FROM members
WHERE member_id = 7;

## Filtering and Sorting

The project demonstrates:

* `WHERE`
* `AND`
* `OR`
* `NOT`
* `ORDER BY`
* `LIMIT`
* `GROUP BY`
* `HAVING`

Example:
SELECT *
FROM books
WHERE available_copies > 0
ORDER BY price DESC
LIMIT 5;

## Aggregate Functions

The project uses the following aggregate functions:

| Function  | Purpose             |
| --------- | ------------------- |
| `COUNT()` | Counts records      |
| `SUM()`   | Calculates totals   |
| `AVG()`   | Calculates averages |
| `MAX()`   | Finds maximum value |
| `MIN()`   | Finds minimum value |

Example:
SELECT AVG(price) AS average_book_price
FROM books;

## JOIN Operations

The project demonstrates several types of JOINs.

### INNER JOIN

Used to retrieve books along with their authors.

SELECT
    b.title,
    a.name AS author_name
FROM books b
INNER JOIN authors a
ON b.author_id = a.author_id;

### LEFT JOIN

Used to retrieve members along with their transactions.

SELECT
    m.name,
    t.transaction_id
FROM members m
LEFT JOIN transactions t
ON m.member_id = t.member_id;

### RIGHT JOIN

Used to identify books that have not been borrowed.

### FULL OUTER JOIN Simulation

MySQL does not directly support `FULL OUTER JOIN`, so the project simulates it using:

LEFT JOIN
UNION
RIGHT JOIN

## Subqueries

The project uses subqueries to solve complex problems.

Examples include:

* Finding books borrowed by recently registered members.
* Finding the most borrowed book.
* Finding members who have never borrowed a book.
* Using `NOT EXISTS` to identify members without transactions.

Example:
SELECT *
FROM members m
WHERE NOT EXISTS (
    SELECT 1
    FROM transactions t
    WHERE t.member_id = m.member_id
);

## Date and Time Functions

The project demonstrates:

* `YEAR()`
* `DATEDIFF()`
* `DATE_FORMAT()`
* `DATE_SUB()`
* `CURDATE()`

Example:
SELECT
    transaction_id,
    borrow_date,
    return_date,
    DATEDIFF(return_date, borrow_date) AS borrowing_days
FROM transactions
WHERE return_date IS NOT NULL;

## Fine Calculation

The library allows a borrowing period of **14 days**.

A fine of **₹5 per late day** is calculated for books returned after the allowed period.

CASE
    WHEN DATEDIFF(return_date, borrow_date) > 14
    THEN (DATEDIFF(return_date, borrow_date) - 14) * 5
    ELSE 0
END

##  String Functions

The project demonstrates:

* `UPPER()`
* `TRIM()`
* `COALESCE()`

Example:

SELECT
    author_id,
    name,
    COALESCE(email, 'Not Provided') AS email
FROM authors;

This replaces missing email values with `"Not Provided"`.

## Window Functions

Advanced SQL analysis is performed using window functions.

The project demonstrates:

* `RANK() OVER()`
* `AVG() OVER()`
* `COUNT() OVER()`

### Book Ranking

Books can be ranked according to their borrowing frequency.

RANK() OVER (
    ORDER BY total_borrowed DESC
) AS borrowing_rank

### Cumulative Borrowing

The project also calculates the cumulative number of books borrowed by each member.

## CASE Expressions

`CASE` is used to categorize and analyze data.

### Membership Status

Members are classified as:

* **Active** → Borrowed a book within the last 6 months.
* **Inactive** → No borrowing within the last 6 months.

### Book Classification

Books are categorized as:

* **New Arrival**
* **Classic**
* **Regular**

## Borrow and Return Operations

### Borrowing a Book

When a member borrows a book:

1. A new transaction is created.
2. The borrow date is recorded.
3. The available copy count is decreased.

INSERT INTO transactions
(member_id, book_id, borrow_date, return_date, fine_amount)
VALUES
(2, 4, CURDATE(), NULL, 0.00);

The available copies are then updated:

UPDATE books
SET available_copies = available_copies - 1
WHERE book_id = 4
AND available_copies > 0;

### Returning a Book

When a book is returned:

1. The return date is recorded.
2. Any applicable fine is calculated.
3. The available copy count is increased.

## Reports

The project generates useful reports such as:

### Complete Library Report

Displays:

* Book ID
* Book title
* Author
* Category
* Price
* Available copies
* Number of times borrowed

### Member Activity Report

Displays:

* Member ID
* Member name
* Email
* Membership date
* Total books borrowed
* Last borrow date
* Membership status

## Technologies Used

* **Database:** MySQL
* **Language:** SQL
* **Database Tools:** MySQL Workbench / phpMyAdmin
* **Version Control:** Git & GitHub

## How to Run the Project

### Step 1: Install MySQL

Install MySQL Server and a MySQL client such as:

* MySQL Workbench
* phpMyAdmin

### Step 2: Open the SQL File

Open the project SQL file in your MySQL environment.

### Step 3: Create the Database

DROP DATABASE IF EXISTS smart_library;

CREATE DATABASE smart_library;

USE smart_library;

### Step 4: Create Tables

Execute the table creation queries for:

authors
books
members
transactions

### Step 5: Insert Sample Data

Run the sample `INSERT` queries.

### Step 6: Execute Analysis Queries

Run the remaining queries to test:

* CRUD
* Filtering
* Sorting
* Aggregation
* JOINs
* Subqueries
* Date functions
* String functions
* Window functions
* CASE expressions
* Reports

## SQL Concepts Covered

This project covers:

✓ CREATE DATABASE
✓ CREATE TABLE
✓ PRIMARY KEY
✓ FOREIGN KEY
✓ AUTO_INCREMENT
✓ UNIQUE
✓ INSERT
✓ SELECT
✓ UPDATE

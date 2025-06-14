
-- Online Bookstore SQL Project
-- Table Creation + Analysis Queries

create database online_book_store;

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


--  ANALYSIS QUERIES

#1) Retrieve all books in the "Fiction" genre?
select *
from books
where genre = 'Fiction';

#2) Find books published after the year 1950?
select *
from books
where Published_Year > 1950;

#3) List all customers from the Canada
select *
from customers
where Country = 'Canada';

#4) Show orders placed in November 2023
SELECT * 
FROM orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30'
order by Order_Date asc;

#5) Retrieve the total stock of books available
select sum(stock) as total_stock_of_books 
from books;

#6) Find the details of the most expensive book
select *
from books
where price = (select max(price) from books);

#7) Show all customers who ordered more than 1 quantity of a book
select *
from orders
where Quantity > 1;

#8) Retrieve all orders where the total amount exceeds $20
select *
from orders
where Total_Amount > 20;

#9) List all genres available in the Books table
select distinct Genre
from books;

#10) Find the book with the lowest stock
SELECT *
FROM books
WHERE stock = (SELECT MIN(stock) FROM books);

#11) Calculate the total revenue generated from all orders
select sum(total_amount) as total_revenue
from orders;

#12) Retrieve the total number of books sold for each genre
select b.genre,sum(o.quantity) as total_number_of_books_sold
from orders as o
join books as b
on o.Book_ID = b.Book_ID
group by b.Genre;

#13) Find the average price of books in the "Fantasy" genre
SELECT AVG(price) AS average_fantasy_price
FROM books
WHERE genre = 'Fantasy';

#14) List customers who have placed at least 2 orders
select c.customer_id , c.Name, count(o.order_id)
from orders as o
join customers as c
on o.Customer_ID = c.Customer_ID
group by Customer_ID
having count(Order_ID) >= 2;

#15) Find the most frequently ordered book
select b.book_id ,b.title , count(o.order_id) as most_frequently_ordered_book
from orders as o
join books as b
on o.Book_ID = b.Book_ID
group by b.Book_ID
order by most_frequently_ordered_book desc
limit 1;

#16) Show the top 3 most expensive books of 'Fantasy' Genre 
select *
from books
where genre = 'Fantasy'
order by Price desc
limit 3;

#17) Retrieve the total quantity of books sold by each author
select b.author , sum(o.quantity) as books_sold_author
from books as b
join orders as o
on b.Book_ID = o.Book_ID
group by b.Author;

#18) List the cities where customers who spent over $30 are located
select c.city , o.total_amount
from customers as c
join orders as o
on o.Customer_ID = c.Customer_ID
where o.Total_Amount > 30;

#19) Find the customer who spent the most on orders
select c.customer_id , c.name , sum(o.total_amount) as most_order_spent
from customers as c
join orders as o
on o.Customer_ID = c.Customer_ID
group by c.Customer_ID
order by  most_order_spent desc
limit 1;

#20) Calculate the stock remaining after fulfilling all orders
SELECT 
    b.book_id,
    b.title,
    b.stock , COALESCE(SUM(o.quantity), 0) AS stock_remaining
FROM books b
LEFT JOIN orders o 
ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.stock;

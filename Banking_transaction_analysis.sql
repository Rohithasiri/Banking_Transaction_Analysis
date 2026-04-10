create database bank_system;
use bank_system;

create table customers(
    customer_id int auto_increment primary key ,
    name varchar(100),
    email varchar(20),
    city varchar(10),
    account_type enum('savings','current'),
    account_balance float);

create table transactions(
    transaction_id int auto_increment primary key,
    customer_id int,
    amount float,
    transaction_type varchar(10),
    transaction_mode varchar(20),
    tran_date datetime default current_timestamp,
    foreign key (customer_id) references customers(customer_id)
    );

INSERT INTO customers (name, email, city, account_type, account_balance) VALUES
    ('Alice', 'alice@gmail.com', 'Hyderabad', 'Savings', 2500.00),
    ('Bob', 'bob@gmail.com', 'Delhi', 'Current', 1200.00),
    ('Charlie', 'charlie@gmail.com', 'Mumbai', 'Savings', 3000.00),
    ('David', 'david@gmail.com', 'Chennai', 'Current', 1800.00),
    ('Anjali', 'anjali@gmail.com', 'Bangalore', 'Savings', 4000.00),
    ('Arjun', 'arjun@gmail.com', 'Hyderabad', 'Current', 2200.00),
    ('Meena', 'meena@gmail.com', 'Delhi', 'Savings', 900.00),
    ('Rahul', 'rahul@gmail.com', 'Mumbai', 'Current', 3500.00),
    ('Sneha', 'sneha@gmail.com', 'Chennai', 'Savings', 2700.00),
    ('Kiran', 'kiran@gmail.com', 'Bangalore', 'Current', 1500.00);

INSERT INTO transactions (customer_id, amount, transaction_type, transaction_mode, tran_date) VALUES
    (1, 1000, 'credit', 'UPI', '2026-04-01 10:00:00'),
    (1, -200, 'debit', 'ATM', '2026-04-02 12:00:00'),
    (2, -500, 'debit', 'NEFT', '2026-04-03 09:30:00'),
    (3, 1500, 'credit', 'IMPS', '2026-04-04 11:15:00'),
    (4, -300, 'debit', 'UPI', '2026-04-05 14:20:00'),
    (5, 2000, 'credit', 'ATM', '2026-04-06 16:45:00'),
    (6, -700, 'debit', 'NEFT', '2026-04-07 18:00:00'),
    (7, 800, 'credit', 'IMPS', '2026-04-08 08:10:00'),
    (8, -400, 'debit', 'UPI', '2026-04-08 19:00:00'),
    (9, 1200, 'credit', 'ATM', '2026-04-09 07:50:00');

select name from customers where account_balance > 1500;

select * from transactions order by tran_date desc;
  
select distinct transaction_mode from transactions;

select * from transactions order by amount desc limit 5;

select name from customers where name like 'A%';

select customer_id,sum(amount) from transactions group by customer_id;

select c.name,t.amount from transactions t join customers c on t.customer_id = c.customer_id;

select customer_id,amount,sum(amount) over(partition by customer_id order by tran_date) from transactions ;

select customer_id,amount,dense_rank() over (order by amount desc) from transactions;

select customer_id,account_balance,dense_rank() over (order by account_balance  desc) from customers;


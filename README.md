# 🏦 Bank System Database

A MySQL-based banking system that models customers and their transactions, with analytical queries using window functions and aggregations.

---

## 📁 Project Structure

```
bank_system/
├── README.md
└── bank_system.sql       # Full schema, seed data, and queries
```

---

## 🗄️ Database Schema

### `customers`

| Column           | Type                        | Description                        |
|------------------|-----------------------------|------------------------------------|
| `customer_id`    | INT, AUTO_INCREMENT, PK     | Unique customer identifier         |
| `name`           | VARCHAR(100)                | Customer's full name               |
| `email`          | VARCHAR(20)                 | Customer's email address           |
| `city`           | VARCHAR(10)                 | City of residence                  |
| `account_type`   | ENUM('savings','current')   | Type of bank account               |
| `account_balance`| FLOAT                       | Current account balance (₹)        |

### `transactions`

| Column             | Type                              | Description                              |
|--------------------|-----------------------------------|------------------------------------------|
| `transaction_id`   | INT, AUTO_INCREMENT, PK           | Unique transaction identifier            |
| `customer_id`      | INT, FK → customers               | Reference to the customer                |
| `amount`           | FLOAT                             | Amount (positive = credit, negative = debit) |
| `transaction_type` | VARCHAR(10)                       | `'credit'` or `'debit'`                  |
| `transaction_mode` | VARCHAR(20)                       | Payment channel (UPI, ATM, NEFT, IMPS)   |
| `tran_date`        | DATETIME (default: NOW)           | Timestamp of the transaction             |

> **Relationship:** Each transaction belongs to one customer via `customer_id` (Foreign Key).

---

## 🌱 Seed Data

### Customers (10 records)

| Name    | City       | Account Type | Balance (₹) |
|---------|------------|--------------|-------------|
| Alice   | Hyderabad  | Savings      | 2,500       |
| Bob     | Delhi      | Current      | 1,200       |
| Charlie | Mumbai     | Savings      | 3,000       |
| David   | Chennai    | Current      | 1,800       |
| Anjali  | Bangalore  | Savings      | 4,000       |
| Arjun   | Hyderabad  | Current      | 2,200       |
| Meena   | Delhi      | Savings      | 900         |
| Rahul   | Mumbai     | Current      | 3,500       |
| Sneha   | Chennai    | Savings      | 2,700       |
| Kiran   | Bangalore  | Current      | 1,500       |

### Transactions (10 records)

| Customer | Amount (₹) | Type   | Mode | Date       |
|----------|------------|--------|------|------------|
| Alice    | +1,000     | Credit | UPI  | 2026-04-01 |
| Alice    | -200       | Debit  | ATM  | 2026-04-02 |
| Bob      | -500       | Debit  | NEFT | 2026-04-03 |
| Charlie  | +1,500     | Credit | IMPS | 2026-04-04 |
| David    | -300       | Debit  | UPI  | 2026-04-05 |
| Anjali   | +2,000     | Credit | ATM  | 2026-04-06 |
| Arjun    | -700       | Debit  | NEFT | 2026-04-07 |
| Meena    | +800       | Credit | IMPS | 2026-04-08 |
| Rahul    | -400       | Debit  | UPI  | 2026-04-08 |
| Sneha    | +1,200     | Credit | ATM  | 2026-04-09 |

---

## 🔍 SQL Queries

### Basic Queries

#### 1. Customers with balance above ₹1,500
```sql
SELECT name FROM customers WHERE account_balance > 1500;
```
Returns all customers whose current balance exceeds ₹1,500.

#### 2. All transactions sorted by latest date
```sql
SELECT * FROM transactions ORDER BY tran_date DESC;
```
Lists all transactions in reverse chronological order.

#### 3. Distinct payment modes used
```sql
SELECT DISTINCT transaction_mode FROM transactions;
```
Returns unique payment channels: UPI, ATM, NEFT, IMPS.

#### 4. Top 5 transactions by amount
```sql
SELECT * FROM transactions ORDER BY amount DESC LIMIT 5;
```
Retrieves the five highest-value transactions.

#### 5. Customers whose name starts with 'A'
```sql
SELECT name FROM customers WHERE name LIKE 'A%';
```
Returns: Alice, Anjali, Arjun.

---

### Aggregate Queries

#### 6. Total transaction amount per customer
```sql
SELECT customer_id, SUM(amount)
FROM transactions
GROUP BY customer_id;
```
Summarizes net transaction amounts grouped by customer.

#### 7. Customer names with their transaction amounts (JOIN)
```sql
SELECT c.name, t.amount
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id;
```
Combines customer names with their respective transaction records.

---

### Window Function Queries

#### 8. Running total of transactions per customer
```sql
SELECT customer_id, amount,
       SUM(amount) OVER (PARTITION BY customer_id ORDER BY tran_date)
FROM transactions;
```
Calculates a cumulative running total of amounts for each customer, ordered by transaction date.

#### 9. Rank transactions by amount (dense rank)
```sql
SELECT customer_id, amount,
       DENSE_RANK() OVER (ORDER BY amount DESC)
FROM transactions;
```
Assigns a dense rank to each transaction from highest to lowest amount (no gaps for ties).

#### 10. Rank customers by account balance (dense rank)
```sql
SELECT customer_id, account_balance,
       DENSE_RANK() OVER (ORDER BY account_balance DESC)
FROM customers;
```
Ranks all customers from highest to lowest account balance.

---

## ⚙️ Setup & Usage

### Prerequisites
- MySQL 5.7+ or MySQL 8.0+

### Run the Script

```bash
mysql -u root -p < bank_system.sql
```

Or paste the SQL directly into MySQL Workbench / any MySQL client.

### Connect to the Database

```sql
USE bank_system;
```

---

## 📌 Key Concepts Demonstrated

| Concept | Example |
|---|---|
| DDL | `CREATE TABLE`, `AUTO_INCREMENT`, `FOREIGN KEY` |
| DML | `INSERT INTO` with multi-row values |
| Filtering | `WHERE`, `LIKE`, `LIMIT` |
| Sorting | `ORDER BY ... DESC` |
| Aggregation | `SUM()`, `GROUP BY` |
| Joins | `INNER JOIN` across two tables |
| Window Functions | `SUM() OVER(PARTITION BY ...)`, `DENSE_RANK() OVER(...)` |

---

## 📝 Notes

- Debit transactions are stored as **negative amounts** (e.g., `-200`).
- The `email` column is limited to `VARCHAR(20)` — consider increasing this for production use.
- The `city` column is limited to `VARCHAR(10)` — may truncate longer city names.
- `FLOAT` is used for balances/amounts; for production, prefer `DECIMAL(10, 2)` for precision.

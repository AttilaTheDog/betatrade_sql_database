# SQL Reference Sheet for Students

This reference sheet contains basic SQL syntax patterns you can adapt for your tasks.

## Connecting to the Database

```bash
# From your Linux server terminal:
docker exec -it betatrade-mysql mysql -uadmin -pbetatrade betatrade_db
```

## Basic SQL Syntax Patterns

### 1. Viewing Table Structure

```sql
-- Show all tables in the database
SHOW TABLES;

-- Show structure of a specific table
DESCRIBE customers;
DESCRIBE accounts;
DESCRIBE trades;
```

### 2. SELECT - Reading Data

**Pattern**: `SELECT columns FROM table;`

```sql
-- Select all columns from a table
SELECT * FROM customers;

-- Select specific columns
SELECT first_name, last_name, email FROM customers;

-- Select with a limit (first 10 rows)
SELECT * FROM customers LIMIT 10;
```

### 3. WHERE - Filtering Data

**Pattern**: `SELECT columns FROM table WHERE condition;`

```sql
-- Exact match
SELECT * FROM customers WHERE status = 'active';

-- Date comparison
SELECT * FROM customers WHERE registration_date >= '2024-01-01';

-- Number comparison
SELECT * FROM trades WHERE profit_loss > 100;

-- Text search (partial match)
SELECT * FROM customers WHERE email LIKE '%@email.de';

-- Multiple conditions (AND)
SELECT * FROM customers 
WHERE status = 'active' AND registration_date >= '2024-01-01';

-- Multiple conditions (OR)
SELECT * FROM trades 
WHERE instrument = 'AAPL' OR instrument = 'MSFT';
```

### 4. ORDER BY - Sorting Results

**Pattern**: `SELECT columns FROM table ORDER BY column ASC/DESC;`

```sql
-- Sort ascending (A-Z, 0-9, oldest-newest)
SELECT * FROM customers ORDER BY last_name ASC;

-- Sort descending (Z-A, 9-0, newest-oldest)
SELECT * FROM customers ORDER BY registration_date DESC;

-- Sort by multiple columns
SELECT * FROM customers ORDER BY last_name ASC, first_name ASC;
```

### 5. Aggregate Functions - Calculations

**Pattern**: `SELECT COUNT/SUM/AVG/MIN/MAX(column) FROM table;`

```sql
-- Count total rows
SELECT COUNT(*) FROM customers;

-- Count non-null values in a column
SELECT COUNT(email) FROM customers;

-- Find minimum value
SELECT MIN(registration_date) FROM customers;

-- Find maximum value
SELECT MAX(profit_loss) FROM trades;

-- Calculate sum
SELECT SUM(profit_loss) FROM trades;

-- Calculate average
SELECT AVG(balance) FROM accounts;
```

### 6. GROUP BY - Grouping Results

**Pattern**: `SELECT column, COUNT(*) FROM table GROUP BY column;`

```sql
-- Count customers per status
SELECT status, COUNT(*) as customer_count
FROM customers
GROUP BY status;

-- Count trades per instrument
SELECT instrument, COUNT(*) as trade_count
FROM trades
GROUP BY instrument;

-- Count with ordering
SELECT status, COUNT(*) as customer_count
FROM customers
GROUP BY status
ORDER BY customer_count DESC;
```

### 7. JOIN - Combining Tables

**Pattern**: `SELECT columns FROM table1 JOIN table2 ON table1.id = table2.foreign_id;`

```sql
-- Simple JOIN (customers with their accounts)
SELECT 
    c.first_name,
    c.last_name,
    a.account_number,
    a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;

-- JOIN with filtering
SELECT 
    c.first_name,
    c.last_name,
    a.account_type
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.account_type = 'VIP';
```

### 8. Date Functions

```sql
-- Extract year from date
SELECT YEAR(registration_date) FROM customers;

-- Extract month from date
SELECT MONTH(registration_date) FROM customers;

-- Format date
SELECT DATE_FORMAT(registration_date, '%Y-%m') FROM customers;

-- Filter by year and month
SELECT * FROM trades 
WHERE YEAR(trade_date) = 2024 AND MONTH(trade_date) = 3;
```

### 9. DELETE - Removing Data

**IMPORTANT**: Always SELECT first to verify what you're deleting!

```sql
-- Step 1: SELECT to verify
SELECT * FROM customers WHERE email = 'test.user1@betatrade-test.de';

-- Step 2: DELETE (only after verification)
DELETE FROM customers WHERE email = 'test.user1@betatrade-test.de';
```

## Useful Commands

```sql
-- Exit MySQL
exit;

-- Clear screen (in some terminals)
\! clear

-- Show current database
SELECT DATABASE();

-- Show query execution time
-- (Automatic in MySQL CLI)
```

## Tips for Success

1. **Start Simple**: Begin with `SELECT * FROM table` to see the data
2. **Build Gradually**: Add one clause at a time (WHERE, then ORDER BY, etc.)
3. **Test Often**: Run your query after each change
4. **Use Comments**: Add `--` before notes to yourself
5. **Format Nicely**: Use multiple lines for readability
6. **Check Syntax**: Most errors are typos or missing semicolons

## Common Mistakes to Avoid

- Forgetting the semicolon `;` at the end
- Using single `=` for comparison (correct: `WHERE status = 'active'`)
- Forgetting quotes around text values: `'text'` not `text`
- Not using quotes around dates: `'2024-01-01'`
- Typos in column names (use `DESCRIBE table` to check)

## Need More Help?

- MySQL Documentation: https://dev.mysql.com/doc/
- W3Schools SQL Tutorial: https://www.w3schools.com/sql/
- Ask your trainer!

---

**Remember**: SQL is a language. Like any language, you learn by practicing and making mistakes. Don't be afraid to experiment!

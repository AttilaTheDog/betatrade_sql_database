-- ============================================
-- BetaTrade AG - Trainer Solutions
-- Day 3 Tasks - Beginner-Friendly Version
-- ============================================

-- Select database
USE betatrade_db;

-- ============================================
-- PART 3: DATABASE EXPLORATION
-- ============================================

-- 3.1 View Table Structure
SHOW TABLES;
DESCRIBE customers;
DESCRIBE accounts;
DESCRIBE trades;

-- 3.2 View Sample Data
SELECT * FROM customers LIMIT 10;
SELECT * FROM accounts LIMIT 10;
SELECT * FROM trades LIMIT 10;

SELECT COUNT(*) as total_customers FROM customers;
SELECT COUNT(*) as total_trades FROM trades;

-- ============================================
-- PART 4: BASIC FILTERING AND SEARCHING
-- ============================================

-- 4.1 Filter Customers
SELECT * FROM customers WHERE status = 'active';
SELECT * FROM customers WHERE status = 'inactive';
SELECT * FROM customers WHERE email LIKE '%@betatrade-test.de';
SELECT * FROM customers WHERE first_name = 'Michael' AND last_name = 'Becker';

-- 4.2 Filter by Date
SELECT * FROM customers WHERE registration_date >= '2024-01-01';
SELECT * FROM customers WHERE registration_date < '2023-01-01';
SELECT * FROM customers 
WHERE registration_date BETWEEN '2024-01-01' AND '2024-01-31';

-- 4.3 Filter Trades
SELECT * FROM trades WHERE instrument = 'AAPL';
SELECT * FROM trades WHERE instrument = 'BTC/USD';
SELECT * FROM trades WHERE trade_type = 'BUY';
SELECT * FROM trades WHERE profit_loss > 500;

-- ============================================
-- PART 5: SORTING AND AGGREGATION
-- ============================================

-- 5.1 Sort Results
SELECT * FROM customers ORDER BY last_name ASC;
SELECT * FROM customers ORDER BY registration_date DESC;
SELECT * FROM trades ORDER BY profit_loss DESC;

-- 5.2 Basic Aggregation
SELECT COUNT(*) as new_customers_2024 
FROM customers 
WHERE registration_date >= '2024-01-01';

SELECT MIN(registration_date) as earliest_customer FROM customers;
SELECT MAX(registration_date) as latest_customer FROM customers;
SELECT SUM(profit_loss) as total_profit FROM trades;
SELECT AVG(balance) as average_balance FROM accounts;

-- 5.3 Grouping
SELECT status, COUNT(*) as customer_count 
FROM customers 
GROUP BY status;

SELECT instrument, COUNT(*) as trade_count 
FROM trades 
GROUP BY instrument 
ORDER BY trade_count DESC;

SELECT trade_type, COUNT(*) as count 
FROM trades 
GROUP BY trade_type;

-- ============================================
-- PART 6: WORKING WITH MULTIPLE TABLES
-- ============================================

-- 6.2 Simple JOIN
SELECT 
    c.first_name,
    c.last_name,
    a.account_number
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;

SELECT 
    c.first_name,
    c.last_name,
    a.account_type
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;

SELECT 
    c.first_name,
    c.last_name,
    a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;

-- 6.3 JOIN with Filtering
SELECT 
    c.first_name,
    c.last_name,
    a.account_number,
    a.account_type,
    a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.account_type = 'VIP';

SELECT 
    c.first_name,
    c.last_name,
    c.registration_date,
    a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE c.registration_date >= '2024-01-01';

SELECT 
    c.first_name,
    c.last_name,
    a.account_type,
    a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.account_type IN ('Premium', 'VIP');

-- ============================================
-- PART 7: ANSWER BUSINESS QUESTIONS
-- ============================================

-- 7.1 New Customer Analysis
-- Show all new customers since 2024-01-01
SELECT first_name, last_name, registration_date
FROM customers
WHERE registration_date >= '2024-01-01'
ORDER BY registration_date;

-- Count new customers
SELECT COUNT(*) as new_customers_2024
FROM customers
WHERE registration_date >= '2024-01-01';
-- Expected: 25 customers

-- 7.2 Trading Activity Analysis
-- Step 1: All trades in March 2024
SELECT * FROM trades 
WHERE YEAR(trade_date) = 2024 AND MONTH(trade_date) = 3;

-- Step 2: Count trades per account in March 2024
SELECT account_id, COUNT(*) as trade_count
FROM trades
WHERE YEAR(trade_date) = 2024 AND MONTH(trade_date) = 3
GROUP BY account_id
ORDER BY trade_count DESC;

-- Step 3: Complete solution with customer names
SELECT 
    c.first_name,
    c.last_name,
    COUNT(t.trade_id) as trade_count
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
WHERE YEAR(t.trade_date) = 2024 AND MONTH(t.trade_date) = 3
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY trade_count DESC
LIMIT 1;
-- Expected: Michael Becker with 38 trades

-- Alternative using DATE_FORMAT (also acceptable)
SELECT 
    c.first_name,
    c.last_name,
    COUNT(t.trade_id) as trade_count
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
WHERE DATE_FORMAT(t.trade_date, '%Y-%m') = '2024-03'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY trade_count DESC
LIMIT 1;

-- Alternative using BETWEEN (also acceptable)
SELECT 
    c.first_name,
    c.last_name,
    COUNT(t.trade_id) as trade_count
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
WHERE t.trade_date BETWEEN '2024-03-01' AND '2024-03-31 23:59:59'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY trade_count DESC
LIMIT 1;

-- Show top 5 traders in March (bonus)
SELECT 
    c.first_name,
    c.last_name,
    COUNT(t.trade_id) as trade_count
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
WHERE YEAR(t.trade_date) = 2024 AND MONTH(t.trade_date) = 3
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY trade_count DESC
LIMIT 5;

-- 7.3 Instrument Popularity
SELECT 
    instrument, 
    COUNT(*) as trade_count
FROM trades
GROUP BY instrument
ORDER BY trade_count DESC;

-- With buy/sell breakdown (bonus)
SELECT 
    instrument,
    COUNT(*) as total_trades,
    SUM(CASE WHEN trade_type = 'BUY' THEN 1 ELSE 0 END) as buys,
    SUM(CASE WHEN trade_type = 'SELL' THEN 1 ELSE 0 END) as sells
FROM trades
GROUP BY instrument
ORDER BY total_trades DESC;

-- 7.4 Account Type Distribution
SELECT 
    account_type,
    COUNT(*) as customer_count
FROM accounts
GROUP BY account_type
ORDER BY customer_count DESC;

-- With average balance
SELECT 
    account_type,
    COUNT(*) as customer_count,
    ROUND(AVG(balance), 2) as average_balance,
    ROUND(SUM(balance), 2) as total_balance
FROM accounts
GROUP BY account_type
ORDER BY customer_count DESC;

-- ============================================
-- PART 8: DATA CLEANUP
-- ============================================

-- 8.1 Identify Test Users
SELECT * FROM customers WHERE email LIKE '%betatrade-test.de%';
SELECT * FROM customers WHERE status = 'inactive';

-- Count test accounts
SELECT COUNT(*) FROM customers WHERE email LIKE '%betatrade-test.de%';
-- Expected: 3 test accounts

-- 8.3 Delete Test Customer
-- Step 1: Verify first
SELECT * FROM customers WHERE email = 'test.user1@betatrade-test.de';

-- Step 2: Delete
DELETE FROM customers WHERE email = 'test.user1@betatrade-test.de';

-- Step 3: Verify deletion
SELECT COUNT(*) as remaining_customers FROM customers;

-- Alternative: Delete all test accounts at once
DELETE FROM customers WHERE email IN (
    'test.user1@betatrade-test.de',
    'test.user2@betatrade-test.de',
    'demo.account@betatrade-test.de'
);

-- ============================================
-- BONUS TASKS
-- ============================================

-- Bonus 1: Complex Filtering
-- Customers registered in 2024 with VIP account
SELECT 
    c.first_name,
    c.last_name,
    c.registration_date,
    a.account_type
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE c.registration_date >= '2024-01-01' 
  AND a.account_type = 'VIP';

-- Trades in March 2024 with profit > 200
SELECT * FROM trades
WHERE YEAR(trade_date) = 2024 
  AND MONTH(trade_date) = 3
  AND profit_loss > 200;

-- Top 5 most profitable trades
SELECT * FROM trades
ORDER BY profit_loss DESC
LIMIT 5;

-- Bonus 2: Advanced Aggregation
-- Total profit/loss per customer
SELECT 
    c.first_name,
    c.last_name,
    COUNT(t.trade_id) as trade_count,
    ROUND(SUM(t.profit_loss), 2) as total_profit
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_profit DESC;

-- Customers with more than 10 trades
SELECT 
    c.first_name,
    c.last_name,
    COUNT(t.trade_id) as trade_count
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(t.trade_id) > 10
ORDER BY trade_count DESC;

-- Average trade profit per instrument
SELECT 
    instrument,
    COUNT(*) as trade_count,
    ROUND(AVG(profit_loss), 2) as avg_profit,
    ROUND(SUM(profit_loss), 2) as total_profit
FROM trades
GROUP BY instrument
ORDER BY avg_profit DESC;

-- ============================================
-- ADDITIONAL USEFUL QUERIES FOR TRAINERS
-- ============================================

-- Verify database initialization
SELECT 
    'customers' as table_name, 
    COUNT(*) as count 
FROM customers
UNION ALL
SELECT 
    'accounts' as table_name, 
    COUNT(*) as count 
FROM accounts
UNION ALL
SELECT 
    'trades' as table_name, 
    COUNT(*) as count 
FROM trades;
-- Expected: 100 customers, 100 accounts, ~600-650 trades

-- Check data distribution
SELECT 
    YEAR(registration_date) as year,
    COUNT(*) as customer_count
FROM customers
GROUP BY YEAR(registration_date)
ORDER BY year;

-- Monthly trading activity overview
SELECT 
    DATE_FORMAT(trade_date, '%Y-%m') as month,
    COUNT(*) as trade_count,
    COUNT(DISTINCT account_id) as active_accounts
FROM trades
WHERE YEAR(trade_date) = 2024
GROUP BY DATE_FORMAT(trade_date, '%Y-%m')
ORDER BY month;

-- ============================================
-- NOTES FOR TRAINERS
-- ============================================

/*
EXPECTED RESULTS:
- Total customers: 100
- New customers since 2024-01-01: 25
- Most active trader March 2024: Michael Becker with 38 trades
- Test accounts for deletion: 3
- Total trades: approximately 600-650

COMMON STUDENT MISTAKES:
1. Forgetting semicolon at end of queries
2. Forgetting quotes around text values: 'text' not text
3. Forgetting quotes around dates: '2024-01-01' not 2024-01-01
4. Wrong comparison operators (using == instead of =)
5. Case sensitivity in column names
6. Forgetting GROUP BY when using COUNT with other columns
7. Not understanding the difference between WHERE and HAVING
8. Forgetting ON clause in JOINs
9. Deleting without first doing SELECT to verify

PROGRESSION DIFFICULTY:
- Parts 3-4: Easy (basic SELECT, WHERE)
- Part 5: Medium (aggregation, GROUP BY)
- Part 6: Medium-Hard (JOINs - expect confusion here)
- Part 7.1: Easy (applies Part 4 skills)
- Part 7.2: Hard (multiple JOINs + GROUP BY + date functions)
- Part 8: Medium (DELETE after SELECT)

TEACHING TIPS:
1. Emphasize: Always SELECT before DELETE
2. Build queries incrementally (add one clause at a time)
3. Use DESCRIBE to show table structure frequently
4. Draw entity-relationship diagrams on whiteboard for JOINs
5. Explain foreign keys using real-world analogies
6. If students struggle with Part 7.2, walk through it step-by-step as shown
7. Encourage pair programming for JOIN exercises
8. Remind them to check SQL_REFERENCE.md when stuck

ASSESSMENT:
Students should be able to complete Parts 3-6 independently.
Part 7.2 is acceptable with assistance.
Bonus tasks are truly optional.
*/

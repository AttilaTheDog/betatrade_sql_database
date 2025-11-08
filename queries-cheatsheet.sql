-- ============================================
-- BetaTrade AG - SQL Query Reference
-- Sample Solutions for Trainers
-- ============================================

-- Select database
USE betatrade_db;

-- ============================================
-- TASK 1: New Customers Since January 2024
-- ============================================

-- Variant 1: Simple solution
SELECT 
    customer_id,
    first_name,
    last_name,
    email,
    registration_date
FROM customers
WHERE registration_date >= '2024-01-01'
ORDER BY registration_date ASC;

-- Variant 2: With additional information
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.registration_date,
    a.account_number,
    a.account_type,
    a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE c.registration_date >= '2024-01-01'
ORDER BY c.registration_date ASC;

-- Variant 3: Count only
SELECT COUNT(*) as new_customers_2024
FROM customers
WHERE registration_date >= '2024-01-01';

-- Expected result: 25 customers

-- ============================================
-- TASK 2a: Most Active Trader in March 2024
-- ============================================

-- Variant 1: Simple solution
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(t.trade_id) as trade_count
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
WHERE YEAR(t.trade_date) = 2024 
  AND MONTH(t.trade_date) = 3
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY trade_count DESC
LIMIT 1;

-- Variant 2: Using DATE_FORMAT
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(t.trade_id) as trade_count
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
WHERE DATE_FORMAT(t.trade_date, '%Y-%m') = '2024-03'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY trade_count DESC
LIMIT 1;

-- Variant 3: Using BETWEEN
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(t.trade_id) as trade_count,
    SUM(t.profit_loss) as total_profit
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
WHERE t.trade_date BETWEEN '2024-03-01' AND '2024-03-31 23:59:59'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY trade_count DESC
LIMIT 1;

-- Expected result: 
-- Michael Becker (customer_id = 5) with 38 trades

-- ============================================
-- TASK 2b: Top 5 Traders in March 2024
-- ============================================

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(t.trade_id) as trade_count,
    ROUND(SUM(t.profit_loss), 2) as total_profit
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
WHERE YEAR(t.trade_date) = 2024 AND MONTH(t.trade_date) = 3
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY trade_count DESC
LIMIT 5;

-- ============================================
-- TASK 3: Inactive Customers (6+ Months)
-- ============================================

-- Variant 1: Customers without trade since June 2024
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    MAX(t.trade_date) as last_trade
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN trades t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING MAX(t.trade_date) < DATE_SUB(NOW(), INTERVAL 6 MONTH)
   OR MAX(t.trade_date) IS NULL
ORDER BY last_trade ASC;

-- Variant 2: Using fixed date (for consistent results)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.status,
    MAX(t.trade_date) as last_trade,
    DATEDIFF('2024-12-01', MAX(t.trade_date)) as days_inactive
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN trades t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.status
HAVING MAX(t.trade_date) < '2024-06-01' OR MAX(t.trade_date) IS NULL
ORDER BY days_inactive DESC;

-- Variant 3: Customers without any trades
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    'Never traded' as status
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN trades t ON a.account_id = t.account_id
WHERE t.trade_id IS NULL;

-- ============================================
-- TASK 4: Delete Test Customers
-- ============================================

-- IMPORTANT: Display first, then delete!

-- Step 1: Identify test customers
SELECT 
    customer_id,
    first_name,
    last_name,
    email,
    status
FROM customers
WHERE email LIKE '%betatrade-test.de%'
   OR status = 'inactive';

-- Step 2: Create backup (outside SQL, in terminal)
-- mysqldump -uadmin -pbetatrade betatrade_db > backup_before_delete.sql

-- Step 3: Delete specific test user
DELETE FROM customers
WHERE email = 'test.user1@betatrade-test.de';

-- Alternative: Delete multiple at once
DELETE FROM customers
WHERE email IN (
    'test.user1@betatrade-test.de',
    'test.user2@betatrade-test.de',
    'demo.account@betatrade-test.de'
);

-- Step 4: Verify deletion
SELECT 
    COUNT(*) as remaining_customers
FROM customers;

-- ============================================
-- BONUS: Useful Analyses
-- ============================================

-- Overview: Trading instruments
SELECT 
    instrument,
    COUNT(*) as trade_count,
    SUM(CASE WHEN trade_type = 'BUY' THEN 1 ELSE 0 END) as buys,
    SUM(CASE WHEN trade_type = 'SELL' THEN 1 ELSE 0 END) as sells,
    ROUND(SUM(profit_loss), 2) as total_profit
FROM trades
GROUP BY instrument
ORDER BY trade_count DESC;

-- Account type distribution
SELECT 
    account_type,
    COUNT(*) as count,
    ROUND(AVG(balance), 2) as avg_balance,
    ROUND(SUM(balance), 2) as total_balance
FROM accounts
GROUP BY account_type
ORDER BY count DESC;

-- Monthly trading activity 2024
SELECT 
    DATE_FORMAT(trade_date, '%Y-%m') as month,
    COUNT(*) as trade_count,
    COUNT(DISTINCT account_id) as active_accounts,
    ROUND(SUM(profit_loss), 2) as total_profit
FROM trades
WHERE YEAR(trade_date) = 2024
GROUP BY DATE_FORMAT(trade_date, '%Y-%m')
ORDER BY month;

-- Top 10 most profitable customers
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(t.trade_id) as trade_count,
    ROUND(SUM(t.profit_loss), 2) as total_profit,
    ROUND(AVG(t.profit_loss), 2) as avg_profit_per_trade
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_profit DESC
LIMIT 10;

-- Customer status overview
SELECT 
    status,
    COUNT(*) as count,
    ROUND(AVG(DATEDIFF(NOW(), registration_date)), 0) as avg_days_registered
FROM customers
GROUP BY status;

-- ============================================
-- DATABASE MANAGEMENT
-- ============================================

-- Show all tables
SHOW TABLES;

-- Show table structure
DESCRIBE customers;
DESCRIBE accounts;
DESCRIBE trades;

-- Check record counts
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

-- Check database size
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) as size_mb
FROM information_schema.TABLES
WHERE table_schema = 'betatrade_db'
ORDER BY (data_length + index_length) DESC;

-- ============================================
-- NOTES FOR TRAINERS
-- ============================================

/*
Expected results:
- New customers since Jan 2024: 25 customers
- Most active trader March 2024: Michael Becker with 38 trades
- Inactive customers: 12-15 customers (depending on definition)
- Test accounts: 3 available for deletion

Common student mistakes:
1. Forgetting JOINs between tables
2. Incorrect date filters (e.g., only year without month)
3. Missing GROUP BY with aggregate functions
4. Deleting without prior backup

Tips for supervision:
- Always SELECT first, then DELETE
- Use EXPLAIN for performance analysis
- Allow different solution approaches
- Explain Foreign Keys (CASCADE)
*/

# INDEX

# BetaTrade Customer Database - Deployment Package

**Created for**: AlphaTech GmbH Training Program

**Date**: November 2024

**Day**: 3 - Docker and SQL

## Package Contents

This package contains all files for the **BetaTrade AG Customer Database** - a complete, production-ready Docker-based MySQL database for training purposes.

### Directory Structure

```
betatrade-database/
├── docker-compose.yml       # Container configuration
├── init-db.sql              # Database schema + 100 customers + ~600 trades
├── README.md                # Complete documentation & instructions
├── .env.example             # Template for environment variables
├── queries-cheatsheet.sql   # Sample solutions for trainers
└── .gitignore              # Git ignore file
```

## Database Content

### Customer Data

- **100 fictional customers**
    - 75 existing customers (2022-2023)
    - 25 new customers (January-June 2024)
    - 3 test accounts for deletion
    - 12-15 inactive customers for tasks

### Trading Instruments

- **Stocks**: AAPL, MSFT, TSLA, GOOGL, AMZN
- **Crypto**: BTC/USD, ETH/USD

### Trading Data

- **Approximately 600 realistic trades**
    - Distribution across 2023-2024
    - Special data for assignment tasks
    - Customer #5 (Michael Becker) with 38 trades in March 2024

## Task-Specific Features

The database contains specially prepared data for the following assignments:

- **Task 1**: 25 customers with `registration_date >= '2024-01-01'`
- **Task 2**: Michael Becker (ID 5) has 38 trades in March 2024 (clear leader)
- **Task 3**: 12-15 customers without trades for 6+ months
- **Task 4**: 3 test users explicitly marked for deletion

## Deployment on Student Servers

### Git Repository

```bash
# Create repository and push filescd betatrade-database
git init
git add .
git commit -m "Initial commit: BetaTrade Database"git remote add origin <your-git-repo>
git push -u origin main
# On each student server:cd /home/student
git clone <your-git-repo> betatrade-database
cd betatrade-database
docker-compose up -d
```

## Deployment Checklist

- [ ]  Docker and Docker Compose installed on all student servers
- [ ]  Port 3306 is available (no other MySQL running)
- [ ]  Files distributed to all 15 servers
- [ ]  Containers started and tested
- [ ]  Students have access to documentation (README.md)
- [ ]  Backup strategy discussed with students

## Default Credentials

**IMPORTANT**: Students should change these

- **Database**: `betatrade_db`
- **User**: `admin`
- **Password**: `betatrade`
- **Port**: `3306`

## Documentation for Students

- **README.md** Database overview and setup instructions
- **SQL_REFERENCE.md** Quick reference with syntax patterns to adapt

## Sample Solutions for Trainers

The file `TRAINER_SOLUTIONS.sql` contains:
- Sample solutions for all tasks
- Alternative solution approaches
- Common student mistakes
- Teaching tips and intervention points
- Time estimates per section
- Notes on difficulty progression

## Quality Assurance

### Expected Results

```sql
-- Basic (should complete independently):
SELECT first_name, last_name 
FROM customers 
WHERE registration_date >= '2024-01-01'
ORDER BY registration_date;

-- Intermediate (may need hints):
SELECT status, COUNT(*) as count
FROM customers
GROUP BY status;

-- Advanced (guidance expected):
SELECT c.first_name, c.last_name, COUNT(t.trade_id) as trades
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN trades t ON a.account_id = t.account_id
WHERE YEAR(t.trade_date) = 2024
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY trades DESC;
```

## Customizations & Extensions

### Adding More Test Data

The `init-db.sql` can easily be extended:

```sql
-- Add more customers
INSERT INTO customers (first_name, last_name, email, ...) VALUES('New', 'Customer', 'new.customer@email.de', ...);

-- Generate more trades
INSERT INTO trades (account_id, trade_date, ...) VALUES ...;
```

## Updates & Maintenance

### Reset Database

```bash
docker-compose down -v  # Deletes all data
docker-compose up -d    # Restarts, init-db.sql is executed again
```

### Create Backup

```bash
docker exec betatrade-mysql mysqldump -uadmin -pbetatrade betatrade_db > backup.sql
```

### Restore Backup

```bash
docker exec -i betatrade-mysql mysql -uadmin -pbetatrade betatrade_db < backup.sql
```

---

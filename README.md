# README

# BetaTrade AG - Customer Database

Fictional trading database for the AlphaTech GmbH training program.

## Overview

This database simulates the customer management system of **BetaTrade AG**, a trading and financial services company. The database contains:

- **100 customers** (75 existing customers, 25 new customers since 2024)
- **Trading instruments**: Stocks (AAPL, MSFT, TSLA, GOOGL, AMZN) and Cryptocurrencies (BTC/USD, ETH/USD)
- **Approximately 600 trades** with realistic distribution
- Special datasets for the assignment tasks

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Minimum 512 MB free RAM
- Port 3306 available

### Installation

1. **Prepare directory**

```bash
cd /home/studentxx/betatrade-database/
```

2. **Start database**

```bash
docker-compose up -d
```

3. **Check status**

```bash
docker-compose ps
docker-compose logs betatrade-db
```

4. **Test connection**

```bash
docker exec -it betatrade-mysql mysql -uadmin -pbetatrade betatrade_db
```

## Credentials

**Default credentials** (to be changed by students):
- **Database**: `betatrade_db`
- **User**: `admin`
- **Password**: `betatrade`
- **Host**: `localhost`
- **Port**: `3306`

### Security Task for Students

Students should change the default credentials:

```sql
-- Inside MySQL container:
ALTER USER 'admin'@'%' IDENTIFIED BY 'NewSecurePassword123!';
FLUSH PRIVILEGES;
```

## Database Schema

### Table: `customers`

Customer master data

| Field | Type | Description |
| --- | --- | --- |
| customer_id | INT | Primary Key |
| first_name | VARCHAR(50) | First name |
| last_name | VARCHAR(50) | Last name |
| email | VARCHAR(100) | Email (unique) |
| phone | VARCHAR(20) | Phone number |
| registration_date | DATE | Registration date |
| status | ENUM | active/inactive |

### Table: `accounts`

Trading accounts

| Field | Type | Description |
| --- | --- | --- |
| account_id | INT | Primary Key |
| customer_id | INT | Foreign Key → customers |
| account_number | VARCHAR(20) | BT-XXXXXX format |
| account_type | ENUM | Standard/Premium/VIP |
| balance | DECIMAL(15,2) | Account balance |
| currency | VARCHAR(3) | Currency (EUR) |
| opened_date | DATE | Opening date |

### Table: `trades`

Trading transactions

| Field | Type | Description |
| --- | --- | --- |
| trade_id | INT | Primary Key |
| account_id | INT | Foreign Key → accounts |
| trade_date | DATETIME | Trading timestamp |
| instrument | VARCHAR(20) | Trading instrument |
| trade_type | ENUM | BUY/SELL |
| quantity | DECIMAL(15,4) | Quantity |
| price | DECIMAL(15,2) | Price |
| profit_loss | DECIMAL(15,2) | Profit/Loss |

## Test Data for Assignments

### New Customers Since January 2024

- **Count**: 25 customers
- **Period**: 01.01.2024 - 21.06.2024
- **SQL hint**: `WHERE registration_date >= '2024-01-01'`

### Most Active Trader in March 2024

- **Customer**: Michael Becker (customer_id = 5)
- **Number of trades**: 38 trades in March 2024
- **SQL hint**: Use `DATE_FORMAT()` or `MONTH()`/`YEAR()`

### Inactive Customers

- **Count**: 12-15 customers
- **Definition**: No trades in the last 6 months (before June 2024)
- **Test accounts** for deletion:
    - test.user1@betatrade-test.de
    - test.user2@betatrade-test.de
    - demo.account@betatrade-test.de

## Useful Commands

### Container Management

```bash
# Start container
docker-compose up -d

# Stop container
docker-compose stop

# Stop and remove container
docker-compose down

# View logs
docker-compose logs -f

# Restart container (in case of problems)
docker-compose restart
```

### MySQL Access

```bash
# Interactive MySQL shell
docker exec -it betatrade-mysql mysql -uadmin -pbetatrade betatrade_db

# Execute SQL file
docker exec -i betatrade-mysql mysql -uadmin -pbetatrade betatrade_db < query.sql

# Create database backup
docker exec betatrade-mysql mysqldump -uadmin -pbetatrade betatrade_db > backup.sql

# Restore backup
docker exec -i betatrade-mysql mysql -uadmin -pbetatrade betatrade_db < backup.sql
```

### Reset Database

```bash
# Stop container and delete volumes
docker-compose down -v

# Restart (init-db.sql will be executed again)
docker-compose up -d
```

## Bonus Task: CSV Import

For the bonus task, a volume for CSV files can be activated:

1. **Modify docker-compose.yml** (uncomment line):

```yaml
volumes:  - ./csv-import:/var/lib/mysql-files:rw
```

1. **Create directory**:

```bash
mkdir -p /home/student/csv-import
chmod 777 /home/student/csv-import
```

1. **Restart container**:

```bash
docker-compose down
docker-compose up -d
```

1. **Test CSV import**:

```sql
LOAD DATA INFILE '/var/lib/mysql-files/new_customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

## Additional Resources

- [MySQL 8.0 Documentation](https://dev.mysql.com/doc/refman/8.0/en/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [SQL Tutorial](https://www.w3schools.com/sql/)

## Notes for Trainers

- The database is exclusively for training purposes
- All data is fictional
- Default credentials must be changed before production use
- Regular backups should be performed (part of learning objectives)

**Teaching Approach**:
- Tasks are structured progressively from easy to hard
- Students should use `SQL_REFERENCE.md` and documentation
- JOINs typically cause the most confusion - budget extra time
- Part 7.2 (most active trader) may require assistance
- Expect students to work slower than estimates
- Encourage building queries incrementally (one clause at a time)

**Assessment**:
- Students should complete Parts 3-6 independently
- Part 7.2 is acceptable with guidance
- Bonus tasks are truly optional for fast learners

See `TRAINER_SOLUTIONS.sql` for complete solutions and detailed teaching notes.

---

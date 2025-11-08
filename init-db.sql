-- ============================================
-- BetaTrade AG - Customer Database
-- Trading & Financial Services Database
-- ============================================

-- Create and use database
CREATE DATABASE IF NOT EXISTS betatrade_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE betatrade_db;

-- ============================================
-- Table: customers
-- Customer master data
-- ============================================
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    registration_date DATE NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_registration_date (registration_date),
    INDEX idx_status (status)
) ENGINE=InnoDB;

-- ============================================
-- Table: accounts
-- Customer trading accounts
-- ============================================
CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    account_type ENUM('Standard', 'Premium', 'VIP') DEFAULT 'Standard',
    balance DECIMAL(15,2) DEFAULT 0.00,
    currency VARCHAR(3) DEFAULT 'EUR',
    opened_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    INDEX idx_customer (customer_id)
) ENGINE=InnoDB;

-- ============================================
-- Table: trades
-- Trading transactions
-- ============================================
CREATE TABLE trades (
    trade_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    trade_date DATETIME NOT NULL,
    instrument VARCHAR(20) NOT NULL,
    trade_type ENUM('BUY', 'SELL') NOT NULL,
    quantity DECIMAL(15,4) NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    profit_loss DECIMAL(15,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE,
    INDEX idx_trade_date (trade_date),
    INDEX idx_account (account_id),
    INDEX idx_instrument (instrument)
) ENGINE=InnoDB;

-- ============================================
-- TEST DATA: Customers
-- ============================================

-- Existing customers (before 2024) - 75 customers
INSERT INTO customers (first_name, last_name, email, phone, registration_date, status) VALUES
('Max', 'Müller', 'max.mueller@email.de', '+49 171 1234501', '2022-03-15', 'active'),
('Anna', 'Schmidt', 'anna.schmidt@email.de', '+49 171 1234502', '2022-05-20', 'active'),
('Thomas', 'Weber', 'thomas.weber@email.de', '+49 171 1234503', '2022-07-10', 'active'),
('Julia', 'Fischer', 'julia.fischer@email.de', '+49 171 1234504', '2022-09-05', 'active'),
('Michael', 'Becker', 'michael.becker@email.de', '+49 171 1234505', '2022-11-12', 'active'),
('Sarah', 'Hoffmann', 'sarah.hoffmann@email.de', '+49 171 1234506', '2023-01-08', 'active'),
('Daniel', 'Koch', 'daniel.koch@email.de', '+49 171 1234507', '2023-02-14', 'active'),
('Laura', 'Bauer', 'laura.bauer@email.de', '+49 171 1234508', '2023-03-22', 'active'),
('Christian', 'Schäfer', 'christian.schaefer@email.de', '+49 171 1234509', '2023-04-18', 'active'),
('Lisa', 'Wagner', 'lisa.wagner@email.de', '+49 171 1234510', '2023-05-25', 'active'),
('Sebastian', 'Schulz', 'sebastian.schulz@email.de', '+49 171 1234511', '2023-06-30', 'active'),
('Jennifer', 'Zimmermann', 'jennifer.zimmermann@email.de', '+49 171 1234512', '2023-07-12', 'active'),
('Markus', 'Krause', 'markus.krause@email.de', '+49 171 1234513', '2023-08-19', 'active'),
('Katharina', 'Meier', 'katharina.meier@email.de', '+49 171 1234514', '2023-09-05', 'active'),
('Andreas', 'Schmitt', 'andreas.schmitt@email.de', '+49 171 1234515', '2023-10-11', 'active'),
('Nicole', 'Werner', 'nicole.werner@email.de', '+49 171 1234516', '2023-11-20', 'active'),
('Stefan', 'Klein', 'stefan.klein@email.de', '+49 171 1234517', '2023-12-05', 'active'),
('Melanie', 'Lehmann', 'melanie.lehmann@email.de', '+49 171 1234518', '2022-04-10', 'active'),
('Oliver', 'Richter', 'oliver.richter@email.de', '+49 171 1234519', '2022-06-15', 'active'),
('Sabine', 'Vogel', 'sabine.vogel@email.de', '+49 171 1234520', '2022-08-20', 'active'),
('Frank', 'Friedrich', 'frank.friedrich@email.de', '+49 171 1234521', '2022-10-25', 'active'),
('Claudia', 'Lange', 'claudia.lange@email.de', '+49 171 1234522', '2023-01-15', 'active'),
('Jürgen', 'Hartmann', 'juergen.hartmann@email.de', '+49 171 1234523', '2023-03-10', 'active'),
('Petra', 'Neumann', 'petra.neumann@email.de', '+49 171 1234524', '2023-05-18', 'active'),
('Ralf', 'Schwarz', 'ralf.schwarz@email.de', '+49 171 1234525', '2023-07-22', 'active'),
('Martina', 'Braun', 'martina.braun@email.de', '+49 171 1234526', '2023-09-28', 'active'),
('Wolfgang', 'Zimmermann', 'wolfgang.zimmermann@email.de', '+49 171 1234527', '2023-11-30', 'active'),
('Susanne', 'Krüger', 'susanne.krueger@email.de', '+49 171 1234528', '2022-02-14', 'active'),
('Uwe', 'Hofmann', 'uwe.hofmann@email.de', '+49 171 1234529', '2022-05-19', 'active'),
('Birgit', 'Schmid', 'birgit.schmid@email.de', '+49 171 1234530', '2022-08-24', 'active'),
('Dieter', 'Berger', 'dieter.berger@email.de', '+49 171 1234531', '2022-11-29', 'active'),
('Karin', 'Engel', 'karin.engel@email.de', '+49 171 1234532', '2023-02-03', 'active'),
('Helmut', 'Arnold', 'helmut.arnold@email.de', '+49 171 1234533', '2023-04-08', 'active'),
('Gisela', 'Schröder', 'gisela.schroeder@email.de', '+49 171 1234534', '2023-06-13', 'active'),
('Hans', 'Sommer', 'hans.sommer@email.de', '+49 171 1234535', '2023-08-18', 'active'),
('Monika', 'Brandt', 'monika.brandt@email.de', '+49 171 1234536', '2023-10-23', 'active'),
('Karl', 'Huber', 'karl.huber@email.de', '+49 171 1234537', '2023-12-28', 'active'),
('Renate', 'Winkler', 'renate.winkler@email.de', '+49 171 1234538', '2022-03-05', 'active'),
('Günter', 'Kaiser', 'guenter.kaiser@email.de', '+49 171 1234539', '2022-06-10', 'active'),
('Inge', 'Fuchs', 'inge.fuchs@email.de', '+49 171 1234540', '2022-09-15', 'active'),
('Horst', 'Herrmann', 'horst.herrmann@email.de', '+49 171 1234541', '2022-12-20', 'active'),
('Erika', 'König', 'erika.koenig@email.de', '+49 171 1234542', '2023-03-25', 'active'),
('Werner', 'Maier', 'werner.maier@email.de', '+49 171 1234543', '2023-06-01', 'active'),
('Helga', 'Walter', 'helga.walter@email.de', '+49 171 1234544', '2023-08-05', 'active'),
('Manfred', 'Peters', 'manfred.peters@email.de', '+49 171 1234545', '2023-10-10', 'active'),
('Christa', 'Stein', 'christa.stein@email.de', '+49 171 1234546', '2023-12-15', 'active'),
('Gerhard', 'Jung', 'gerhard.jung@email.de', '+49 171 1234547', '2022-01-20', 'active'),
('Heike', 'Hahn', 'heike.hahn@email.de', '+49 171 1234548', '2022-04-25', 'active'),
('Joachim', 'Schubert', 'joachim.schubert@email.de', '+49 171 1234549', '2022-07-30', 'active'),
('Angelika', 'Vogel', 'angelika.vogel@email.de', '+49 171 1234550', '2022-10-05', 'active'),
('Klaus', 'Möller', 'klaus.moeller@email.de', '+49 171 1234551', '2023-01-10', 'active'),
('Ursula', 'Winter', 'ursula.winter@email.de', '+49 171 1234552', '2023-04-15', 'active'),
('Bernhard', 'Kraus', 'bernhard.kraus@email.de', '+49 171 1234553', '2023-07-20', 'active'),
('Elfriede', 'Roth', 'elfriede.roth@email.de', '+49 171 1234554', '2023-10-25', 'active'),
('Peter', 'Baumann', 'peter.baumann@email.de', '+49 171 1234555', '2022-02-28', 'active'),
('Margot', 'Schuster', 'margot.schuster@email.de', '+49 171 1234556', '2022-06-03', 'active'),
('Heinrich', 'Keller', 'heinrich.keller@email.de', '+49 171 1234557', '2022-09-08', 'active'),
('Waltraud', 'Ludwig', 'waltraud.ludwig@email.de', '+49 171 1234558', '2022-12-13', 'active'),
('Rainer', 'Groß', 'rainer.gross@email.de', '+49 171 1234559', '2023-03-18', 'active'),
('Hildegard', 'Krause', 'hildegard.krause@email.de', '+49 171 1234560', '2023-06-23', 'active'),

-- Inactive test customers (designated for deletion)
('Test', 'User1', 'test.user1@betatrade-test.de', '+49 171 9999901', '2022-01-10', 'inactive'),
('Test', 'User2', 'test.user2@betatrade-test.de', '+49 171 9999902', '2022-03-15', 'inactive'),
('Demo', 'Account', 'demo.account@betatrade-test.de', '+49 171 9999903', '2022-06-20', 'inactive'),

-- Inactive customers (no trades for extended period)
('Martin', 'Alt', 'martin.alt@email.de', '+49 171 1234561', '2022-02-10', 'active'),
('Ingrid', 'Still', 'ingrid.still@email.de', '+49 171 1234562', '2022-04-15', 'active'),
('Franz', 'Ruhig', 'franz.ruhig@email.de', '+49 171 1234563', '2022-06-20', 'active'),
('Gertrud', 'Passiv', 'gertrud.passiv@email.de', '+49 171 1234564', '2022-08-25', 'active'),
('Emil', 'Inaktiv', 'emil.inaktiv@email.de', '+49 171 1234565', '2022-10-30', 'active'),
('Rosa', 'Schläfer', 'rosa.schlaefer@email.de', '+49 171 1234566', '2023-01-05', 'active'),
('Bruno', 'Pause', 'bruno.pause@email.de', '+49 171 1234567', '2023-03-10', 'active'),
('Frieda', 'Warten', 'frieda.warten@email.de', '+49 171 1234568', '2023-05-15', 'active'),
('Otto', 'Stille', 'otto.stille@email.de', '+49 171 1234569', '2023-07-20', 'active'),
('Else', 'Langsam', 'else.langsam@email.de', '+49 171 1234570', '2023-09-25', 'active'),
('Gustav', 'Abwesend', 'gustav.abwesend@email.de', '+49 171 1234571', '2023-11-30', 'active'),
('Martha', 'Vergessen', 'martha.vergessen@email.de', '+49 171 1234572', '2022-05-10', 'active'),

-- New customers 2024 - 25 customers (for task "since January 2024")
('Tim', 'Neumeier', 'tim.neumeier@email.de', '+49 171 2024001', '2024-01-05', 'active'),
('Lena', 'Stark', 'lena.stark@email.de', '+49 171 2024002', '2024-01-12', 'active'),
('Jonas', 'Richter', 'jonas.richter@email.de', '+49 171 2024003', '2024-01-19', 'active'),
('Emma', 'Berg', 'emma.berg@email.de', '+49 171 2024004', '2024-01-26', 'active'),
('Leon', 'Wolf', 'leon.wolf@email.de', '+49 171 2024005', '2024-02-02', 'active'),
('Mia', 'Schwarz', 'mia.schwarz@email.de', '+49 171 2024006', '2024-02-09', 'active'),
('Felix', 'Klein', 'felix.klein@email.de', '+49 171 2024007', '2024-02-16', 'active'),
('Hannah', 'Weiß', 'hannah.weiss@email.de', '+49 171 2024008', '2024-02-23', 'active'),
('Paul', 'Grün', 'paul.gruen@email.de', '+49 171 2024009', '2024-03-01', 'active'),
('Sophie', 'Blau', 'sophie.blau@email.de', '+49 171 2024010', '2024-03-08', 'active'),
('Lukas', 'Gelb', 'lukas.gelb@email.de', '+49 171 2024011', '2024-03-15', 'active'),
('Marie', 'Rot', 'marie.rot@email.de', '+49 171 2024012', '2024-03-22', 'active'),
('David', 'Braun', 'david.braun@email.de', '+49 171 2024013', '2024-03-29', 'active'),
('Emily', 'Grau', 'emily.grau@email.de', '+49 171 2024014', '2024-04-05', 'active'),
('Noah', 'Silber', 'noah.silber@email.de', '+49 171 2024015', '2024-04-12', 'active'),
('Lara', 'Gold', 'lara.gold@email.de', '+49 171 2024016', '2024-04-19', 'active'),
('Ben', 'Kupfer', 'ben.kupfer@email.de', '+49 171 2024017', '2024-04-26', 'active'),
('Lea', 'Bronze', 'lea.bronze@email.de', '+49 171 2024018', '2024-05-03', 'active'),
('Finn', 'Platin', 'finn.platin@email.de', '+49 171 2024019', '2024-05-10', 'active'),
('Anna', 'Diamant', 'anna.diamant@email.de', '+49 171 2024020', '2024-05-17', 'active'),
('Jan', 'Kristall', 'jan.kristall@email.de', '+49 171 2024021', '2024-05-24', 'active'),
('Clara', 'Perle', 'clara.perle@email.de', '+49 171 2024022', '2024-05-31', 'active'),
('Elias', 'Rubin', 'elias.rubin@email.de', '+49 171 2024023', '2024-06-07', 'active'),
('Nora', 'Saphir', 'nora.saphir@email.de', '+49 171 2024024', '2024-06-14', 'active'),
('Maximilian', 'Topas', 'maximilian.topas@email.de', '+49 171 2024025', '2024-06-21', 'active');

-- ============================================
-- TEST DATA: Accounts
-- ============================================

-- Create accounts for all customers
INSERT INTO accounts (customer_id, account_number, account_type, balance, currency, opened_date)
SELECT 
    customer_id,
    CONCAT('BT-', LPAD(customer_id, 6, '0')) as account_number,
    CASE 
        WHEN customer_id <= 20 THEN 'VIP'
        WHEN customer_id <= 60 THEN 'Premium'
        ELSE 'Standard'
    END as account_type,
    ROUND(RAND() * 50000 + 5000, 2) as balance,
    'EUR' as currency,
    registration_date as opened_date
FROM customers;

-- ============================================
-- TEST DATA: Trades
-- ============================================

-- Stock and Crypto instruments (NO Forex)
-- Stocks: AAPL, MSFT, TSLA, GOOGL, AMZN
-- Crypto: BTC/USD, ETH/USD

-- Trades for active traders (Customer 1-60): Many trades in 2024
INSERT INTO trades (account_id, trade_date, instrument, trade_type, quantity, price, profit_loss)
SELECT 
    a.account_id,
    DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 180) DAY) as trade_date,
    ELT(FLOOR(RAND() * 7) + 1, 'AAPL', 'MSFT', 'TSLA', 'GOOGL', 'AMZN', 'BTC/USD', 'ETH/USD') as instrument,
    IF(RAND() > 0.5, 'BUY', 'SELL') as trade_type,
    ROUND(RAND() * 100 + 1, 2) as quantity,
    ROUND(RAND() * 500 + 50, 2) as price,
    ROUND((RAND() - 0.5) * 1000, 2) as profit_loss
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
WHERE c.customer_id BETWEEN 1 AND 60
AND c.status = 'active'
LIMIT 400;

-- IMPORTANT: Customer #5 (Michael Becker) - Many trades in March 2024 (for task)
-- 38 trades in March 2024
INSERT INTO trades (account_id, trade_date, instrument, trade_type, quantity, price, profit_loss) VALUES
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-01 09:15:00', 'AAPL', 'BUY', 50, 178.50, 250.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-01 14:30:00', 'MSFT', 'BUY', 30, 412.30, 180.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-02 10:20:00', 'TSLA', 'SELL', 25, 198.75, -120.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-03 11:45:00', 'GOOGL', 'BUY', 15, 138.90, 95.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-04 08:30:00', 'BTC/USD', 'BUY', 0.5, 62500.00, 1500.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-05 13:15:00', 'AMZN', 'BUY', 40, 178.20, 320.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-06 09:50:00', 'ETH/USD', 'SELL', 2.5, 3450.00, -85.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-07 15:20:00', 'AAPL', 'SELL', 45, 182.10, 162.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-08 10:10:00', 'MSFT', 'BUY', 25, 415.80, 190.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-09 14:40:00', 'TSLA', 'BUY', 30, 195.40, -150.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-10 11:25:00', 'GOOGL', 'SELL', 20, 141.25, 125.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-11 09:35:00', 'BTC/USD', 'SELL', 0.3, 64200.00, 510.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-12 13:50:00', 'AMZN', 'SELL', 35, 180.50, 280.50),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-13 10:30:00', 'ETH/USD', 'BUY', 3.0, 3520.00, 210.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-14 15:45:00', 'AAPL', 'BUY', 55, 175.90, -145.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-15 09:20:00', 'MSFT', 'SELL', 28, 418.90, 234.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-16 14:15:00', 'TSLA', 'BUY', 22, 201.30, 176.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-17 11:55:00', 'GOOGL', 'BUY', 18, 139.75, 89.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-18 08:40:00', 'BTC/USD', 'BUY', 0.4, 63800.00, 1020.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-19 13:30:00', 'AMZN', 'BUY', 38, 179.40, 304.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-20 10:05:00', 'ETH/USD', 'SELL', 2.8, 3580.00, 196.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-21 15:10:00', 'AAPL', 'SELL', 50, 183.20, 260.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-22 09:45:00', 'MSFT', 'BUY', 32, 413.50, 192.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-23 14:25:00', 'TSLA', 'SELL', 27, 196.80, -135.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-24 11:30:00', 'GOOGL', 'SELL', 16, 142.10, 113.60),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-25 08:55:00', 'BTC/USD', 'SELL', 0.45, 65100.00, 1170.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-26 13:40:00', 'AMZN', 'SELL', 42, 181.30, 336.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-27 10:20:00', 'ETH/USD', 'BUY', 3.2, 3495.00, 224.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-28 15:35:00', 'AAPL', 'BUY', 48, 177.60, -144.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-29 09:50:00', 'MSFT', 'SELL', 29, 420.10, 247.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-30 14:05:00', 'TSLA', 'BUY', 24, 199.50, 192.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-31 11:15:00', 'GOOGL', 'BUY', 19, 140.30, 95.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-31 13:00:00', 'BTC/USD', 'BUY', 0.6, 64500.00, 1548.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-31 14:30:00', 'AMZN', 'BUY', 36, 180.00, 288.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-31 15:15:00', 'ETH/USD', 'SELL', 2.6, 3565.00, 182.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-31 16:00:00', 'AAPL', 'SELL', 52, 184.50, 312.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-31 16:45:00', 'MSFT', 'BUY', 31, 416.70, 186.00),
((SELECT account_id FROM accounts WHERE customer_id = 5), '2024-03-31 17:30:00', 'TSLA', 'SELL', 26, 197.90, -130.00);

-- Trades for moderate traders in March 2024
INSERT INTO trades (account_id, trade_date, instrument, trade_type, quantity, price, profit_loss)
SELECT 
    a.account_id,
    DATE_ADD('2024-03-01', INTERVAL FLOOR(RAND() * 31) DAY) as trade_date,
    ELT(FLOOR(RAND() * 7) + 1, 'AAPL', 'MSFT', 'TSLA', 'GOOGL', 'AMZN', 'BTC/USD', 'ETH/USD') as instrument,
    IF(RAND() > 0.5, 'BUY', 'SELL') as trade_type,
    ROUND(RAND() * 50 + 5, 2) as quantity,
    ROUND(RAND() * 400 + 100, 2) as price,
    ROUND((RAND() - 0.5) * 500, 2) as profit_loss
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
WHERE c.customer_id BETWEEN 1 AND 4
LIMIT 80;

-- Old trades for inactive customers (last trades before June 2024)
INSERT INTO trades (account_id, trade_date, instrument, trade_type, quantity, price, profit_loss)
SELECT 
    a.account_id,
    DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 365) DAY) as trade_date,
    ELT(FLOOR(RAND() * 7) + 1, 'AAPL', 'MSFT', 'TSLA', 'GOOGL', 'AMZN', 'BTC/USD', 'ETH/USD') as instrument,
    IF(RAND() > 0.5, 'BUY', 'SELL') as trade_type,
    ROUND(RAND() * 30 + 5, 2) as quantity,
    ROUND(RAND() * 300 + 50, 2) as price,
    ROUND((RAND() - 0.5) * 200, 2) as profit_loss
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
WHERE c.customer_id BETWEEN 61 AND 75
LIMIT 150;

-- ============================================
-- Database Statistics Output
-- ============================================

SELECT 'Database successfully initialized!' as Status;
SELECT COUNT(*) as 'Total Customers' FROM customers;
SELECT COUNT(*) as 'Total Accounts' FROM accounts;
SELECT COUNT(*) as 'Total Trades' FROM trades;
SELECT COUNT(*) as 'New Customers since Jan 2024' FROM customers WHERE registration_date >= '2024-01-01';

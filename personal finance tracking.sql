create database personal_finance;
use personal_finance;
CREATE TABLE User (user_id INT PRIMARY KEY,username VARCHAR(50) ,email VARCHAR(100) );
INSERT INTO User (user_id, username, email) VALUES (1, 'Allen', 'Allen.com'),
(2, 'john', 'john.com'),
(3, 'smith', 'smith.com'),
(4,'scott','scott.com'),
(5, 'blake', 'blake.com');

CREATE TABLE Accounts (account_id INT PRIMARY KEY,user_id INT,account_name VARCHAR(50) NOT NULL,balance int,FOREIGN KEY (user_id) REFERENCES User(user_id));
INSERT INTO Accounts (account_id, user_id, account_name, balance)VALUES (11, 1, 'Savings Account', 10000),
(22, 2, 'Checking Account', 20000),
(33,3,'personal account',30000),
(44,4,'management account',40000),
(55,5,'benificiary account',50000);

CREATE TABLE Transactions (transaction_id INT PRIMARY KEY,account_id INT,amount int,transaction_date DATE ,description TEXT,FOREIGN KEY (account_id) REFERENCES Accounts(account_id));
INSERT INTO Transactions (transaction_id, account_id, amount, transaction_date, description) VALUES (101, 11,2500, '2024-03-15', 'Withdrawal for groceries'),
(102, 22, 3500, '2024-03-16', 'Deposit from paycheck'),
(103,33,4500,'2024-03-17','withdrawal for rent'),
(104,44,5500,'2024-03-18','deposit from bank'),
(105,55,6500,'2024-03-19','withdraw from bank');

CREATE TABLE Categories (category_id INT PRIMARY KEY,category_name VARCHAR(50));
INSERT INTO Categories (category_id, category_name) VALUES (6, 'Groceries'),(7, 'Salary'),(8, 'Rent'),(9,'waterbill'),(10,'currentbill');

-- Query to Retrieve User Information Along with Their Account Details:
SELECT u.user_id, u.username, u.email, a.account_id, a.account_name, a.balance FROM User u INNER JOIN Accounts a ON u.user_id = a.user_id;

-- Query to Retrieve Transaction History with User Information:
SELECT u.username, a.account_name, t.amount, t.transaction_date, t.description FROM User u INNER JOIN Accounts a ON u.user_id = a.user_id INNER JOIN Transactions t ON a.account_id = t.account_id;

-- Query to Calculate Total Balance for Each User:
SELECT u.user_id, u.username, SUM(a.balance) AS total_balance FROM User u INNER JOIN Accounts a ON u.user_id = a.user_id GROUP BY u.user_id, u.username;

-- Query to Retrieve Transactions Made After a Certain Date:
SELECT * FROM Transactions WHERE transaction_date > '2024-03-15';

-- Trigger
DELIMITER $$

CREATE TRIGGER UpdateAccountBalance AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    DECLARE current_balance INT;
    
    -- Retrieve the current balance of the account
    SELECT balance INTO current_balance
    FROM Accounts
    WHERE account_id = NEW.account_id;
    
    -- Update the balance based on the transaction type
    IF NEW.amount > 0 THEN
        -- Deposit transaction
        UPDATE Accounts
        SET balance = current_balance + NEW.amount
        WHERE account_id = NEW.account_id;
    ELSE
        -- Withdrawal transaction
        UPDATE Accounts
        SET balance = current_balance - ABS(NEW.amount)
        WHERE account_id = NEW.account_id;
    END IF;
END$$

DELIMITER ;

set sql_safe_updates=0;
 update accounts set balance = 21500 where account_id=22; 
 select * from accounts;
 




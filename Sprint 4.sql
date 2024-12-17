### NIVELL 1 ###
### PREPARACIÓ BBDD ##

-- Crear base de dades i taules
CREATE DATABASE IF NOT EXISTS modelat_sql_roser4;
USE modelat_sql_roser4;

CREATE TABLE IF NOT EXISTS companies (
	id VARCHAR(15) PRIMARY KEY,
	company_name VARCHAR(255), 	
	phone VARCHAR(50),
	email VARCHAR(100),
	country VARCHAR(100),	
	website VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS credit_cards (
	id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(15),
	iban VARCHAR(50),	
	pan VARCHAR(50),		
	pin VARCHAR(4),	
	cvv VARCHAR(4),
	track1 VARCHAR(100),
	track2 VARCHAR(100),
	expiring_date VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS users (
	id INT PRIMARY KEY,
    name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(50),
	email VARCHAR(100),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS transactions (
	id VARCHAR(50) PRIMARY KEY,
	card_id VARCHAR(50),
	business_id VARCHAR(15),
	timestamp TIMESTAMP,
	amount DECIMAL(10,2),
	declined BOOLEAN,
	product_ids VARCHAR(255),
	user_id INT,
	lat FLOAT,
	longitude FLOAT
    );

-- Afegir dades a les taules    
LOAD DATA INFILE 'companies.csv' INTO TABLE companies
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
    
SELECT *
FROM companies;
    
LOAD DATA INFILE 'credit_cards.csv' INTO TABLE credit_cards
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;
    
SELECT *
FROM credit_cards;

LOAD DATA INFILE 'transactions.csv' INTO TABLE transactions
	FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;

Select *
FROM transactions;

LOAD DATA INFILE 'users_usa.csv' INTO TABLE users
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
    
Select *
FROM users;

LOAD DATA INFILE 'users_uk.csv' INTO TABLE users
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES;

Select *
FROM users;

LOAD DATA INFILE 'users_ca.csv' INTO TABLE users
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES;

Select *
FROM users;

-- Afegim les relacions
ALTER TABLE transactions ADD CONSTRAINT fk_user_id foreign key (user_id)
REFERENCES users (id); 

ALTER TABLE transactions ADD CONSTRAINT fk_card_id foreign key (card_id)
REFERENCES credit_cards (id); 

ALTER TABLE transactions ADD CONSTRAINT fk_business_id foreign key (business_id)
REFERENCES companies (id); 

### NIVELL 1 ###
## EXERCICI 1 ##

-- Usuaris amb més de 30 transaccions
SELECT users.id, users.name AS nom, users.surname AS cognom, COUNT(transactions.id) as numero_transaccions
FROM users
JOIN transactions ON users.id = transactions.user_id
GROUP BY user_id
HAVING numero_transaccions > 30
ORDER BY numero_transaccions DESC;

-- Mitjana d'amount per IBAN de targetes a Donec Ltd
SELECT credit_cards.iban, ROUND(AVG(amount)) AS mitjana_transaccio_donec
FROM transactions
JOIN credit_cards ON credit_cards.id = transactions.card_id
WHERE business_id = (SELECT id
	FROM companies
	WHERE company_name='Donec Ltd')
GROUP BY credit_cards.iban
ORDER BY mitjana_transaccio_donec DESC;

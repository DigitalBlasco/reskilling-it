### NIVELL 1 ###
### PREPARACIÓ BBDD ##

-- Creem una base de dades
CREATE DATABASE IF NOT EXISTS modelat_sql_roser;
USE modelat_sql_roser;

-- Creem la taula transactions
    CREATE TABLE IF NOT EXISTS transactions (
        id VARCHAR(15) PRIMARY KEY
    );

-- Creem la taula users
    CREATE TABLE IF NOT EXISTS users (
        id VARCHAR(15) PRIMARY KEY
    );
    
-- Creem la taula credit cards
    CREATE TABLE IF NOT EXISTS credit_cards (
        id VARCHAR(50) PRIMARY KEY
    );
    
-- Creem la taula companies
    CREATE TABLE IF NOT EXISTS companies (
        id VARCHAR(15) PRIMARY KEY
    );

-- Afegim columnes a la taula transactions
ALTER TABLE transactions
ADD card_id VARCHAR(15),
ADD business_id VARCHAR(15),
ADD timestamp TIMESTAMP,
ADD amount DECIMAL(10,2),
ADD declined TINYINT(1),
ADD product_ids VARCHAR(255),
ADD user_id VARCHAR(15),
ADD lat FLOAT,
ADD longitude FLOAT;

-- Afegim columnes a la taula users
ALTER TABLE users
ADD name VARCHAR(100),
ADD surname VARCHAR(100),
ADD phone VARCHAR(50),
ADD email VARCHAR(100),
ADD birth_date VARCHAR(100),
ADD country VARCHAR(150),
ADD city VARCHAR(150),
ADD postal_code VARCHAR(100),
ADD address VARCHAR(255);

-- Afegim columnes a la taula credit cards
ALTER TABLE credit_cards
ADD user_id VARCHAR(15),
ADD iban VARCHAR(50),	
ADD pan VARCHAR(50),		
ADD pin VARCHAR(4),	
ADD cvv INT,
ADD track1 VARCHAR(100),
ADD track2 VARCHAR(100),
ADD expiring_date VARCHAR(20);

-- Afegim columnes a la taula companies
ALTER TABLE companies
ADD company_name VARCHAR(255), 	
ADD phone VARCHAR(50),
ADD email VARCHAR(100),
ADD country VARCHAR(100),	
ADD website VARCHAR(255);

-- Demanem que carregui dades del csv
LOAD DATA INFILE 'transactions.csv' INTO TABLE transactions;
show variables like 'secure_file_priv';

# Finalment hem pujat els arxius manualment amb el Wizard com vam acordar amb Alana


-- Afegim els altres arxius de users 
LOAD DATA INFILE 'users_uk.csv' INTO TABLE users
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES;

LOAD DATA INFILE 'users_ca.csv' INTO TABLE users
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES;


-- Modifiquem la taula users
ALTER TABLE users
MODIFY COLUMN id INT;

-- Modifiquem la taula transaction
ALTER TABLE transactions
MODIFY COLUMN user_id INT;

-- Afegim les relacions
ALTER TABLE transactions ADD CONSTRAINT fk_user_id foreign key (user_id)
REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE; 

ALTER TABLE transactions ADD CONSTRAINT fk_card_id foreign key (card_id)
REFERENCES credit_cards (id) ON DELETE CASCADE ON UPDATE CASCADE; 

ALTER TABLE transactions ADD CONSTRAINT fk_business_id foreign key (business_id)
REFERENCES companies (id) ON DELETE CASCADE ON UPDATE CASCADE; 


### NIVELL 1 ###
## EXERCICI 1 ##

-- I ara responem la pregunta: usuaris amb més de 30 transaccions
SELECT *
FROM users
WHERE id in (SELECT user_id
	FROM transactions
	GROUP BY user_id
	HAVING COUNT(id) > 30
	ORDER BY COUNT(id) DESC)
;


### NIVELL 1 ###
## EXERCICI 2 ##

-- Mitjana d'amount per IBAN de targetes a Donec Ltd
SELECT credit_cards.iban, AVG(amount) AS mitjana_transaccio_donec
FROM transactions
JOIN credit_cards ON credit_cards.id = transactions.card_id
WHERE business_id = (SELECT id
	FROM companies
	WHERE company_name='Donec Ltd')
GROUP BY credit_cards.iban
ORDER BY AVG(amount) DESC;


### NIVELL 2 ###
## EXERCICI 1 ##



### NIVELL 3 ###
## EXERCICI 1 ##




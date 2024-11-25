### NIVELL 1 ###
## EXERCICI 1 ##

SHOW TABLES;

-- Creem la taula credit_card
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(15) PRIMARY KEY,
	iban VARCHAR(255),
	pan VARCHAR(255),
	pin VARCHAR(4),
	cvv VARCHAR(3),
	expiring_date VARCHAR(255)
);

SHOW TABLES;

SELECT *
FROM credit_card;


### NIVELL 1 ###
## EXERCICI 2 ##

UPDATE credit_card SET iban = 'R323456312213576817699999' WHERE id = 'CcU-2938';

SELECT *
from credit_card
WHERE id = 'CcU-2938';


### NIVELL 1 ###
## EXERCICI 3 ##

### NIVELL 1 ###
## EXERCICI 4 ##


### NIVELL 2 ###
## EXERCICI 1 ##


### NIVELL 2 ###
## EXERCICI 2 ##


### NIVELL 2 ###
## EXERCICI 3 ##


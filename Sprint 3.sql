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

alter table transaction add constraint fk_credit_card_id foreign key (credit_card_id)
references credit_card (id) on delete cascade on update cascade;

### NIVELL 1 ###
## EXERCICI 2 ##

UPDATE credit_card SET iban = 'R323456312213576817699999' WHERE id = 'CcU-2938';

SELECT *
from credit_card
WHERE id = 'CcU-2938';


### NIVELL 1 ###
## EXERCICI 3 ##

# - Nou usuari a "transaction" amb les dades que ens han donat
SET foreign_key_checks=0;

INSERT into transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11', '0');

SET foreign_key_checks=1;


### NIVELL 1 ###
## EXERCICI 4 ##

# - Eliminar la columna "pan" de la taula credit_card
ALTER TABLE credit_card
DROP COLUMN pan;

SELECT *
FROM credit_card;


### NIVELL 2 ###
## EXERCICI 1 ##

# - Eliminar el registre
DELETE 
FROM transaction
WHERE id='02C6201E-D90A-1859-B4EE-88D2986D3B02';


### NIVELL 2 ###
## EXERCICI 2 ##

# - Crear la vista de màrqueting 
CREATE VIEW VistaMarketing AS
SELECT company.company_name, company.phone, company.country, avg(amount)
FROM transaction
LEFT JOIN company
	ON company.id = transaction.company_id
    WHERE declined = 0
GROUP BY company.id
ORDER BY avg(amount) DESC;

SELECT *
FROM vistamarketing;

### NIVELL 2 ###
## EXERCICI 3 ##

# - Filtra la vista de màrqueting per a empreses només a alemanya
SELECT *
FROM vistamarketing
WHERE country ='Germany';


### NIVELL 3 ###
## EXERCICI 1 ##




### NIVELL 3 ###
## EXERCICI 2 ##
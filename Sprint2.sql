### NIVELL 1 ###
## EXERCICI 1

# A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules. 
# Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen. 
# Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables.


SELECT * FROM transactions.transaction;

SELECT * FROM transactions.company;

### NIVELL 1 ###
## EXERCICI 2

# - Llistat dels països que estan fent compres.
SELECT distinct country
FROM company
RIGHT JOIN transaction
	ON company.id = transaction.company_id

ORDER BY country ASC;

# - Des de quants països es realitzen les compres.
SELECT count(distinct country)
FROM company
RIGHT JOIN transaction
	ON company.id = transaction.company_id;
    
# - Identifica la companyia amb la mitjana més gran de vendes.
SELECT company.company_name, ROUND(avg(amount),2 ) AS mitjana
FROM company
RIGHT JOIN transaction
	ON company.id = transaction.company_id
	WHERE declined = 0
GROUP BY company.company_name
ORDER BY avg(amount) DESC
LIMIT 1;  


### NIVELL 1 ###
## EXERCICI 3

# - Mostra totes les transaccions realitzades per empreses d'Alemanya.
Select *
FROM transaction
WHERE company_id in (
	SELECT id
	FROM company 
	WHERE country ='Germany');

#  - Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
Select company_name
FROM company
WHERE id in ( 
	SELECT distinct company_id
	FROM transaction
	WHERE amount > (
		SELECT avg(amount)
		FROM transaction) 
	)
ORDER by company_name;

# - Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
Select company_name
FROM company
WHERE id NOT in ( 
	Select company_id
	FROM transaction
	)
ORDER by company_name;


### NIVELL 2 ###
## EXERCICI 1

# - Cinc dies amb més ingressos per vendes
SELECT date(timestamp) AS data, SUM(amount) AS ingressos
FROM transaction
WHERE declined = 0
GROUP BY date(timestamp)
ORDER BY SUM(amount) DESC
LIMIT 5;

### NIVELL 2 ###
## EXERCICI 2

# - Mitjana de vendes per país, de major a menor
SELECT country as "Pais", ROUND(avg(amount),2) as "Mitjana de vendes"
FROM company
LEFT JOIN transaction
	ON company.id = transaction.company_id
	WHERE declined = 0
GROUP BY country
ORDER BY avg(amount) DESC;  

### NIVELL 2 ###
## EXERCICI 3

# - Transaccions en el mateix país que "Non Institute"
# - Amb JOIN i subconsultes
Select *
FROM transaction
RIGHT JOIN company
	ON company.id = transaction.company_id
WHERE country = (
	SELECT country
	FROM company
	WHERE company_name = 'Non Institute');
    
# - Transaccions en el mateix país que "Non Institute"
SELECT *
FROM transaction
WHERE company_id IN (
	SELECT id
	FROM company
	WHERE country = (
		SELECT country
		FROM company
		WHERE company_name = 'Non Institute')
	)
;


### NIVELL 3 ###
## EXERCICI 1

# - Transaccions entre 100 i 200€ de 29 d'abril 2021, 20 de juliol 2021 i 13 de març 2022
SELECT company.company_name, company.phone, company.country, transaction.timestamp, transaction.amount
FROM company
JOIN transaction
	ON company.id = transaction.company_id
WHERE DATE(timestamp) in ('2021-04-29','2021-07-20','2022-03-13')
	AND amount between 100 and 200
    
ORDER BY amount DESC;
    

### NIVELL 3 ###
## EXERCICI 2

# - Quantitat de transaccions especificant si tenen més de 4 transaccions o menys.
SELECT company.company_name,
CASE 
	WHEN COUNT(transaction.id) < 4 THEN "Menys de 4"
    ELSE "4 o més"
END AS transaccions
FROM transaction
JOIN company
	ON company.id = transaction.company_id
GROUP BY company.company_name
ORDER BY COUNT(transaction.id) DESC;
    
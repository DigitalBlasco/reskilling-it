### NIVELL 3 ###

## EXERCICI 1
# - Transaccions entre 100 i 200€ de 29 d'abril 2021, 20 de juliol 2021 i 13 de març 2022

SELECT company.company_name, company.phone, company.country, transaction.timestamp, transaction.amount
FROM company
JOIN transaction
	ON company.id = transaction.company_id
WHERE DATE(timestamp) in ('2021-04-29','2021-07-20','2021-03-13')
	AND amount > 100 AND amount < 200
    
ORDER BY amount DESC;
    

## EXERCICI 2

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



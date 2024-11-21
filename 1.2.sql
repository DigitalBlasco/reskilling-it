### NIVELL 1 ###

## EXERCICI 2

# - Llistat dels països que estan fent compres.
SELECT distinct country
FROM company
LEFT JOIN transaction
	ON company.id = transaction.company_id

ORDER BY country ASC;

# - Des de quants països es realitzen les compres.
SELECT count(distinct country)
FROM company
LEFT JOIN transaction
	ON company.id = transaction.company_id;
    
# - Identifica la companyia amb la mitjana més gran de vendes.
SELECT company.company_name, avg(amount)
FROM company
LEFT JOIN transaction
	ON company.id = transaction.company_id
	WHERE declined = 0
GROUP BY company.company_name
ORDER BY avg(amount) DESC;   
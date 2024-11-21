### NIVELL 2 ###

## EXERCICI 1

# - Cinc dies amb més ingressos per vendes
SELECT date(timestamp), SUM(amount)
FROM transaction
WHERE declined = 0
GROUP BY date(timestamp)
ORDER BY SUM(amount) DESC
LIMIT 5;

## EXERCICI 2

# - Mitjana de vendes per país, de major a menor
SELECT country as "Pais", avg(amount) as "Mitjana de vendes"
FROM company
LEFT JOIN transaction
	ON company.id = transaction.company_id
	WHERE declined = 0
GROUP BY country
ORDER BY avg(amount) DESC;  


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
# - Només amb subconsultes
SELECT *
FROM transaction
WHERE company_id in (
	SELECT id
	FROM company
	WHERE id in (
		SELECT id
		FROM company
		WHERE country = (
			SELECT country
			FROM company
			WHERE company_name = 'Non Institute'
		)
        
	)
    
);
    
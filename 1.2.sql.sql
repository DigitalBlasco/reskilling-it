SELECT distinct country
FROM company
LEFT JOIN transaction
	ON company.id = transaction.company_id

ORDER BY country ASC;

SELECT count(distinct country)
FROM company
LEFT JOIN transaction
	ON company.id = transaction.company_id;

SELECT company.company_name, avg(amount)
FROM company
LEFT JOIN transaction
	ON company.id = transaction.company_id
GROUP BY company.company_name
ORDER BY avg(amount) DESC
LIMIT 1;   

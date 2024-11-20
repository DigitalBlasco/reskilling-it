SELECT * 
FROM company 
LEFT JOIN transaction
	ON company.id = transaction.company_id
WHERE country ='Germany';

Select *
FROM transaction
WHERE company_id in (
	SELECT id
	FROM company 
	WHERE country ='Germany');



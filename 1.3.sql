Select *
FROM transaction
WHERE company_id in (
	SELECT id
	FROM company 
	WHERE country ='Germany');

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

Select company_name
FROM company
WHERE id NOT in ( 
	Select company_id
	FROM transaction
	)
ORDER by company_name;


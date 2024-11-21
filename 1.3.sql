Select *
### NIVELL 1 ###

## EXERCICI 3

# - Mostra totes les transaccions realitzades per empreses d'Alemanya.

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


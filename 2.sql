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



## EXERCICI 3


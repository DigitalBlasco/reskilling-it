SELECT date(timestamp), SUM(amount)
FROM transaction
WHERE declined = 0
GROUP BY date(timestamp)
ORDER BY SUM(amount) DESC
LIMIT 5;